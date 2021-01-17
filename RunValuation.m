
function [O_EnterpriseValueLow, O_EnterpriseValueHigh, ...
          O_ProjectedRevenueSeries, O_ProjectedVariableCostSeries, O_ProjectedCashFlowSeries,...
          O_PlotPeriod, O_ErrorCode]...
  = RunValuation (I_Country, I_Industry, I_Debt, I_NonCashAssets, I_Cash,
  I_YearlyFixedCost,
  I_YearlyFinancialEntries
  )
  
  %Assumption 1:
  %Revenue = Cost + Income
  %Revenue = FixedCost + VariableCost + CashFlow + IncomeDelta(Assume = 0)
  %CashFlow = Revenue - FixedCost - VariableCost

  %Assumption 2:
  %Assets = Liabilities + Equity
  %Assume Liabilities = Debt (Valid assumption for most businesses)  
  %Equity = Assets(Inclusing Cash) - Debt
  
  %%%%%%%%%%%%%Load parameters%%%%%%%%%%%%%%
  ModelConstants;
  LoadCountryModelParameters;
  SimulationParameters;
  ErrorCode;
  O_ErrorCode = NoError;
  %%%%%%%%%%%%%Cost of Capital calculations%%%%%%%%%%%%%%
  V_CountryDeafultSpread = P_10YearCountryGvmtBondYieldUSD - P_10YearUSGvmtBondYield;
  V_RiskFreeRate = P_10YearCountryGvmtBondYield - V_CountryDeafultSpread;

  V_CountryRiskPremiumLow = C_USRiskPremiumLow + V_CountryDeafultSpread;
  V_CountryRiskPremiumHigh =  C_USRiskPremiumHigh + V_CountryDeafultSpread;

  V_UnLeveredIndustryBeta = ReducedListIndustryBeta(I_Industry);

  V_ValueofEquity = I_NonCashAssets + I_Cash - I_Debt;
  if(V_ValueofEquity<=0)
   O_ErrorCode = NegativeEquity;
  endif

  V_DebtToEquityRatio = I_Debt/V_ValueofEquity;
    
  V_CompanyRelativeRisk = V_UnLeveredIndustryBeta*(1+((1-P_CountryCorporateTaxRate)*V_DebtToEquityRatio));
  
  V_CostOfEquityLow = V_RiskFreeRate+V_CountryRiskPremiumLow+(V_CompanyRelativeRisk*C_USRiskPremiumLow);
  V_CostOfEquityHigh = V_RiskFreeRate+V_CountryRiskPremiumHigh+(V_CompanyRelativeRisk*C_USRiskPremiumHigh);
  
  V_CostOfCapitalLow = (V_CostOfEquityLow*(V_ValueofEquity/(V_ValueofEquity+I_Debt))) + (P_CostOfDebt*(I_Debt/(I_Debt+V_ValueofEquity))*(1-P_CountryCorporateTaxRate));
  V_CostOfCapitalHigh = (V_CostOfEquityHigh*(V_ValueofEquity/(V_ValueofEquity+I_Debt))) + (P_CostOfDebt*(I_Debt/(I_Debt+V_ValueofEquity))*(1-P_CountryCorporateTaxRate));

  if(P_Production == false)
    V_CostOfCapitalLow
    V_CostOfCapitalHigh
  endif
  %%%%%%%%%%%%%Growth Estimations%%%%%%%%%%%%%%
  %I_YearlyFinancialEntries contains Revenue and VariableCost components
  V_PastYearsRecoreded = length(I_YearlyFinancialEntries)/2;
  V_PastRevenueSeries = zeros(1, V_PastYearsRecoreded);
  V_PastVariableCostSeries = zeros(1, V_PastYearsRecoreded);
  V_EstimatedRevenueGrowthRateSeries = zeros(1, V_PastYearsRecoreded-1);
  V_EstimatedVariableCostGrowthRateSeries = zeros(1, V_PastYearsRecoreded-1);

  %Reverse order to be in direction of time  
  for n = 1:V_PastYearsRecoreded
    V_PastRevenueSeries(V_PastYearsRecoreded-n+1) = I_YearlyFinancialEntries((2*n)-1);
    V_PastVariableCostSeries(V_PastYearsRecoreded-n+1) = I_YearlyFinancialEntries(2*n);
  end
  
  %Get instantenous yearly growth rates
  for n = 1:(V_PastYearsRecoreded-1)
    V_EstimatedRevenueGrowthRateSeries(n) = (V_PastRevenueSeries(n+1)/V_PastRevenueSeries(n))-1;
    V_EstimatedVariableCostGrowthRateSeries(n) = (V_PastVariableCostSeries(n+1)/V_PastVariableCostSeries(n))-1;
  end

  %Weight a year's rate propotional to how far in the past it is.
  for n = 1:(V_PastYearsRecoreded-1)
    V_EstimatedRevenueGrowthRateSeries(n) = V_EstimatedRevenueGrowthRateSeries(n) * n / (V_PastYearsRecoreded-1);
    V_EstimatedVariableCostGrowthRateSeries(n) = V_EstimatedVariableCostGrowthRateSeries(n) * n / (V_PastYearsRecoreded-1);
  end

  V_EstimatedRevenueGrowthRateSeries = V_EstimatedRevenueGrowthRateSeries +1;
  V_EstimatedVariableCostGrowthRateSeries = V_EstimatedVariableCostGrowthRateSeries +1;
  
  V_EstimatedRevenueGrowthRate = (prod(V_EstimatedRevenueGrowthRateSeries).^(1/(V_PastYearsRecoreded-1))) -1;
  V_EstimatedVariableCostGrowthRate = (prod(V_EstimatedVariableCostGrowthRateSeries).^(1/(V_PastYearsRecoreded-1))) -1;
  
  if(P_Production == false)
    V_EstimatedRevenueGrowthRate
    V_EstimatedVariableCostGrowthRate
  endif

  
  if(V_EstimatedRevenueGrowthRate < P_TerminalGrowthRate)
    P_TerminalGrowthRate = V_EstimatedRevenueGrowthRate + EPSILON;
  endif
  %%%%%%%%%%%%%Past Period%%%%%%%%%%%%%%
  PastTimeLine = (-V_PastYearsRecoreded+1):0;
  %Revenue%
  V_PastRevenueGrowthRateSeries = zeros(1, V_PastYearsRecoreded);
  V_PastRevenueGrowthRateSeries(:) = V_EstimatedRevenueGrowthRate;
  
  %VariableCost%  
  V_PastVariableCostGrowthRateSeries = zeros(1, V_PastYearsRecoreded);
  V_PastVariableCostGrowthRateSeries(:) = V_EstimatedVariableCostGrowthRate;

  %CashFlow%
  V_PastCashFlowSeries = zeros(1, V_PastYearsRecoreded);
  V_PastCashFlowSeries = V_PastRevenueSeries - V_PastVariableCostSeries - I_YearlyFixedCost;
  
  %%%%%%%%%%%%%Growth Period%%%%%%%%%%%%%%  
  GrowthPeriodTimeLine = 0:P_NumOfGrowthYears;

  %Revenue%

  V_GrowthRevenueSeries = zeros(1, P_NumOfGrowthYears + 1);
  V_GrowthRevenueSeries(1) = V_PastRevenueSeries(end);  

  V_GrowthPeriodRevenueGrowthRateSeries = zeros(1, P_NumOfGrowthYears + 1);
  V_GrowthPeriodRevenueGrowthRateSeries(:) = V_EstimatedRevenueGrowthRate ;
  
  for n = 2:length(V_GrowthRevenueSeries)
    V_GrowthRevenueSeries(n) =(V_GrowthRevenueSeries(n-1)*(1+V_GrowthPeriodRevenueGrowthRateSeries(n)));
  end

  %VariableCost%
  V_GrowthVariableCostSeries = zeros(1, P_NumOfGrowthYears + 1);
  V_GrowthVariableCostSeries(1) = V_PastVariableCostSeries(end);  

  V_GrowthPeriodVariableCostGrowthRateSeries = zeros(1, P_NumOfGrowthYears + 1);
  V_GrowthPeriodVariableCostGrowthRateSeries(:) = V_EstimatedVariableCostGrowthRate ;
  
  for n = 2:length(V_GrowthVariableCostSeries)
    V_GrowthVariableCostSeries(n) =(V_GrowthVariableCostSeries(n-1)*(1+V_GrowthPeriodVariableCostGrowthRateSeries(n)));
  end

  %CashFlow%
  V_GrowthCashFlowSeries = zeros(1, P_NumOfGrowthYears + 1);
  V_GrowthCashFlowSeries = V_GrowthRevenueSeries - V_GrowthVariableCostSeries - I_YearlyFixedCost;

  %%%%%%%%%%%%%WindDown Period%%%%%%%%%%%%%%  
  WindDownPeriodTimeLine = P_NumOfGrowthYears:P_NumOfGrowthYears + P_NumOfWindDownYears;

  %Revenue%
  V_WindDownRevenueSeries = zeros(1, P_NumOfWindDownYears + 1);
  V_WindDownRevenueSeries(1) = V_GrowthRevenueSeries(end);  

  V_WindDownPeriodRevenueGrowthRateSeries = zeros(1, P_NumOfWindDownYears + 1);
  RevenueYearlyDropInGrowth = (V_EstimatedRevenueGrowthRate - P_TerminalGrowthRate)/P_NumOfWindDownYears;
  V_WindDownPeriodRevenueGrowthRateSeries(:) =  V_EstimatedRevenueGrowthRate: - RevenueYearlyDropInGrowth: P_TerminalGrowthRate;
  
  for n = 2:length(V_GrowthRevenueSeries)
    V_WindDownRevenueSeries(n) =(V_WindDownRevenueSeries(n-1)*(1+V_WindDownPeriodRevenueGrowthRateSeries(n)));
  end

  %VariableCost%
  V_WindDownVariableCostSeries = zeros(1, P_NumOfWindDownYears + 1);
  V_WindDownVariableCostSeries(1) = V_GrowthVariableCostSeries(end);  

  V_WindDownPeriodVariableCostGrowthRateSeries = zeros(1, P_NumOfWindDownYears + 1);
  VariableCostYearlyDropInGrowth = (V_EstimatedVariableCostGrowthRate - P_TerminalGrowthRate)/P_NumOfWindDownYears;
  V_WindDownPeriodVariableCostGrowthRateSeries(:) =  V_EstimatedVariableCostGrowthRate: - VariableCostYearlyDropInGrowth: P_TerminalGrowthRate;
  
  for n = 2:length(V_GrowthVariableCostSeries)
    V_WindDownVariableCostSeries(n) =(V_WindDownVariableCostSeries(n-1)*(1+V_WindDownPeriodVariableCostGrowthRateSeries(n)));
  end

  %CashFlow%
  V_WindDownCashFlowSeries = zeros(1, P_NumOfWindDownYears + 1);
  V_WindDownCashFlowSeries = V_WindDownRevenueSeries - V_WindDownVariableCostSeries - I_YearlyFixedCost;

  %%%%%%%%%%%%%Terminal Period%%%%%%%%%%%%%%  
  TerminalPeriodTimeLine = P_NumOfWindDownYears+P_NumOfGrowthYears:P_FuturePlotPeriod;

  %Revenue%
  V_TerminalRevenueSeries = zeros(1, P_FuturePlotPeriod - P_NumOfGrowthYears - P_NumOfWindDownYears + 1);
  V_TerminalRevenueSeries(1) = V_WindDownRevenueSeries(end);

  V_TerminalPeriodRevenueGrowthRateSeries = zeros(1, P_FuturePlotPeriod - P_NumOfGrowthYears - P_NumOfWindDownYears + 1);
  V_TerminalPeriodRevenueGrowthRateSeries(:) = P_TerminalGrowthRate ;

  for n = 2:length(V_TerminalRevenueSeries)
    V_TerminalRevenueSeries(n) =(V_TerminalRevenueSeries(n-1)*(1+V_TerminalPeriodRevenueGrowthRateSeries(n)));
  end

  %VariableCost%
  V_TerminalVariableCostSeries = zeros(1, P_FuturePlotPeriod - P_NumOfGrowthYears - P_NumOfWindDownYears + 1);
  V_TerminalVariableCostSeries(1) = V_WindDownVariableCostSeries(end);

  V_TerminalPeriodVariableCostGrowthRateSeries = zeros(1, P_FuturePlotPeriod - P_NumOfGrowthYears - P_NumOfWindDownYears + 1);
  V_TerminalPeriodVariableCostGrowthRateSeries(:) = P_TerminalGrowthRate ;

  for n = 2:length(V_TerminalVariableCostSeries)
    V_TerminalVariableCostSeries(n) =(V_TerminalVariableCostSeries(n-1)*(1+V_TerminalPeriodVariableCostGrowthRateSeries(n)));
  end

  %CashFlow%
  V_TerminalCashFlowSeries = zeros(1, P_FuturePlotPeriod - P_NumOfGrowthYears - P_NumOfWindDownYears + 1);
  V_TerminalCashFlowSeries = V_TerminalRevenueSeries - V_TerminalVariableCostSeries - I_YearlyFixedCost;
  
  %%%%%%%%%%%%%DCF%%%%%%%%%%%%%%  
  
  FutureTimeLine = 0:P_FuturePlotPeriod;
  V_FutureCashFlowSeries = cat(2, V_GrowthCashFlowSeries(1:end-1),
                            V_WindDownCashFlowSeries(1:end-1),
                            V_TerminalCashFlowSeries);

  V_DiscountedCashFlowSeriesLow = zeros(1, P_FuturePlotPeriod+1);
  V_DiscountedCashFlowSeriesHigh = zeros(1, P_FuturePlotPeriod+1);

  for n = 1:(P_FuturePlotPeriod+1)
    V_DiscountedCashFlowSeriesLow(n) = V_FutureCashFlowSeries(n) / ((1+V_CostOfCapitalHigh)^(n-1));
    V_DiscountedCashFlowSeriesHigh(n) = V_FutureCashFlowSeries(n) / ((1+V_CostOfCapitalLow)^(n-1));
  end

  V_DCFSummationLow = sum(V_DiscountedCashFlowSeriesLow);
  V_DCFSummationHigh = sum(V_DiscountedCashFlowSeriesHigh);

  if(P_Production == false)
    V_DCFSummationLow
    V_DCFSummationHigh
  endif
  
  %%%%%%%%%%%%%Valuation%%%%%%%%%%%%%%  

  if(V_DCFSummationLow > I_NonCashAssets)
    V_ValuationLow = V_DCFSummationLow;
  else
    V_ValuationLow = I_NonCashAssets;
   O_ErrorCode = ValueLimitedToAssets;
  endif
  
  if(V_DCFSummationHigh > I_NonCashAssets)
    V_ValuationHigh = V_DCFSummationHigh;
  else
    V_ValuationHigh = I_NonCashAssets;
  endif

  %%%%%%%%%%%%%Formulate Outputs%%%%%%%%%%%%%%  
      
  O_EnterpriseValueLow = V_ValuationLow - I_Debt + I_Cash;
  O_EnterpriseValueHigh = V_ValuationHigh - I_Debt + I_Cash;
  
  O_ProjectedRevenueSeries = cat(2, V_PastRevenueSeries(1:end-1),
                            V_GrowthRevenueSeries(1:end-1),
                            V_WindDownRevenueSeries(1:end-1),
                            V_TerminalRevenueSeries);

  O_ProjectedVariableCostSeries = cat(2, V_PastVariableCostSeries(1:end-1),
                            V_GrowthVariableCostSeries(1:end-1),
                            V_WindDownVariableCostSeries(1:end-1),
                            V_TerminalVariableCostSeries);

  O_ProjectedCashFlowSeries = cat(2, V_PastCashFlowSeries(1:end-1),
                            V_GrowthCashFlowSeries(1:end-1),
                            V_WindDownCashFlowSeries(1:end-1),
                            V_TerminalCashFlowSeries);
  
  O_PlotPeriod = length(O_ProjectedRevenueSeries);
  
  O_ErrorCode;

  if(P_Production == false)
    O_EnterpriseValueLow
    O_EnterpriseValueHigh
  endif
  
  %%%%%%%%%%%%%Metrics%%%%%%%%%%%%%%  
  
%  if(V_FutureCashFlowSeries(1)>0)
%   O_PricetoCashFlowLow = O_CompanyValuationLow/V_FutureCashFlowSeries(1)
%    O_PricetoCashFlowHigh = O_CompanyValuationHigh/V_FutureCashFlowSeries(1)
%  endif
  %%%%%%%%%%%%%Plotting%%%%%%%%%%%%%%  
if(P_Production == false)

  figure(1);  
  plot(PastTimeLine, V_PastRevenueSeries, ";Past Revenue;", "marker", '+', "linewidth", 5, 
  PastTimeLine, V_PastVariableCostSeries, ";Past Variable Cost;", "marker", '+', "linewidth", 5, 
  PastTimeLine, V_PastCashFlowSeries, ";Past Cash Flow;", "marker", '+', "linewidth", 5, 
  GrowthPeriodTimeLine, V_GrowthRevenueSeries, ";Projected Growth Period Revenue;", "marker", '+', "linewidth", 5, "linestyle", ":",
  GrowthPeriodTimeLine, V_GrowthVariableCostSeries, ";Projected Growth Period Variable Cost;", "marker", '+', "linewidth", 5, "linestyle", ":",
  GrowthPeriodTimeLine, V_GrowthCashFlowSeries, ";Projected Growth Period Cash Flow;", "marker", '+', "linewidth", 5, "linestyle", ":",
  WindDownPeriodTimeLine, V_WindDownRevenueSeries, ";Projected Wind Down Period Revenue;", "marker", '+', "linewidth", 5, "linestyle", ":",
  WindDownPeriodTimeLine, V_WindDownVariableCostSeries, ";Projected Wind Down Period Variable Cost;", "marker", '+', "linewidth", 5, "linestyle", ":",
  WindDownPeriodTimeLine, V_WindDownCashFlowSeries, ";Projected Wind Down Period Cash Flow;", "marker", '+', "linewidth", 5, "linestyle", ":",
  TerminalPeriodTimeLine, V_TerminalRevenueSeries, ";Projected Terminal Growth Revenue;", "marker", '+', "linewidth", 5, "linestyle", "-.",
  TerminalPeriodTimeLine, V_TerminalVariableCostSeries, ";Projected Terminal Growth Variable Cost;", "marker", '+', "linewidth", 5, "linestyle", "-.",
  TerminalPeriodTimeLine, V_TerminalCashFlowSeries, ";Projected Terminal Growth Cash Flow;", "marker", '+', "linewidth", 5, "linestyle", "-."
  );
  xlabel ("Years");
  ylabel ("Egp");
  grid;
  legend ("location", "northwest");
  
  figure(2);  
  plot(  PastTimeLine, V_PastRevenueGrowthRateSeries * 100, ";Past Revenue Growth Rate;", "marker", '+', "linewidth", 5,
  PastTimeLine, V_PastVariableCostGrowthRateSeries * 100, ";Past Variable Cost Growth Rate;", "marker", '+', "linewidth", 5,
  GrowthPeriodTimeLine, V_GrowthPeriodRevenueGrowthRateSeries * 100, ";Projected Growth Period Revenue Growth Rate;", "marker", '+', "linewidth", 5, "linestyle", ":",
  GrowthPeriodTimeLine, V_GrowthPeriodVariableCostGrowthRateSeries * 100, ";Projected Growth Period Variable CostGrowth Rate;", "marker", '+', "linewidth", 5, "linestyle", ":",
  WindDownPeriodTimeLine, V_WindDownPeriodRevenueGrowthRateSeries * 100, ";Projected Wind Down Period Revenue Growth Rate;", "marker", '+', "linewidth", 5, "linestyle", ":",
  WindDownPeriodTimeLine, V_WindDownPeriodVariableCostGrowthRateSeries * 100, ";Projected Wind Down Period Variable Cost Growth Rate;", "marker", '+', "linewidth", 5, "linestyle", ":",
  TerminalPeriodTimeLine, V_TerminalPeriodRevenueGrowthRateSeries * 100, ";Projected Terminal Period Revenue Growth Rate;", "marker", '+', "linewidth", 5, "linestyle", "-.",
  TerminalPeriodTimeLine, V_TerminalPeriodVariableCostGrowthRateSeries * 100, ";Projected Terminal Period Variable Cost Growth Rate;", "marker", '+', "linewidth", 5, "linestyle", "-."
  );
  xlabel ("Years");
  ylabel ("%");
  grid;
  legend ("location", "northwest");

  figure(3);  
  plot(FutureTimeLine, V_FutureCashFlowSeries , ";Future Cash Flow;", "marker", '+', "linewidth", 5,
  FutureTimeLine, V_DiscountedCashFlowSeriesLow , ";Discounted Cash Flow Low Bound;", "marker", '+', "linewidth", 5,
  FutureTimeLine, V_DiscountedCashFlowSeriesHigh , ";Discounted Cash Flow High Bound;", "marker", '+', "linewidth", 5
  );
  xlabel ("Years");
  ylabel ("Egp");
  grid;
  legend ("location", "northwest");

 
 endif
  
endfunction
