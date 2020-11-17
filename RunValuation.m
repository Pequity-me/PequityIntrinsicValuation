
function Valuation = RunValuation (I_Industry, I_ValueofDebt, I_ValueofEquity,
  I_TTMRevenue, I_T_1YearRevenue, I_T_2YearRevenue,
  I_FixedCost,
  I_TTMNetIncome, I_TTMDepreciation, I_AccPayable, I_AccReceivable, I_InventoryChange,
  I_TTMPPEInvestment, 
  I_TTMDebtIssuance, I_TTMDebtRepayment, I_TTMStockIssuance, I_TTMStockRepayment, I_TTMDistributedDividends,
  I_T_1YearNetIncome, I_T_2YearNetIncome)
  
  %%%%%%%%%%%%%Load parameters%%%%%%%%%%%%%%
  ModelConstants;
  ModelParameters;
  SimulationParameters;
  
  %%%%%%%%%%%%%Cost of Capital calculations%%%%%%%%%%%%%%
  V_CountryDeafultSpread = P_10YearCountryGvmtBondYieldUSD - P_10YearUSGvmtBondYield;
  V_RiskFreeRate = P_10YearCountryGvmtBondYield - V_CountryDeafultSpread;

  V_CountryRiskPremiumLow = C_USRiskPremiumLow + V_CountryDeafultSpread;
  V_CountryRiskPremiumHigh =  C_USRiskPremiumHigh + V_CountryDeafultSpread;

  V_LeveredIndustryBeta = IndustryBeta(I_Industry);

  V_DebtToEquityRatio = I_ValueofDebt/I_ValueofEquity;
    
  V_CompanyRelativeRisk = V_LeveredIndustryBeta*(1+((1-P_CountryCorporateTaxRate)*V_DebtToEquityRatio));
  
  V_CostOfEquityLow = V_RiskFreeRate+V_CountryRiskPremiumLow+(V_CompanyRelativeRisk*C_USRiskPremiumLow);
  V_CostOfEquityHigh = V_RiskFreeRate+V_CountryRiskPremiumHigh+(V_CompanyRelativeRisk*C_USRiskPremiumHigh);
  
  V_CostOfCapitalLow = (V_CostOfEquityLow*(I_ValueofEquity/(I_ValueofEquity+I_ValueofDebt))) + (P_CostOfDebt*(I_ValueofDebt/(I_ValueofDebt+I_ValueofEquity))*(1-P_CountryCorporateTaxRate));
  V_CostOfCapitalHigh = (V_CostOfEquityHigh*(I_ValueofEquity/(I_ValueofEquity+I_ValueofDebt))) + (P_CostOfDebt*(I_ValueofDebt/(I_ValueofDebt+I_ValueofEquity))*(1-P_CountryCorporateTaxRate));

  %%%%%%%%%%%%%Income to Cashflow%%%%%%%%%%%%%%
    
  V_TTMCashFlowOperations = I_TTMNetIncome + I_TTMDepreciation + I_AccPayable - I_AccReceivable - I_InventoryChange;
  V_TTMCashFlowInvesting = - I_TTMPPEInvestment;
  V_TTMCashFlowFinancing = I_TTMDebtIssuance - I_TTMDebtRepayment + I_TTMStockIssuance - I_TTMStockRepayment - I_TTMDistributedDividends;
  
  V_TTMNetCashFlow = V_TTMCashFlowOperations + V_TTMCashFlowInvesting + V_TTMCashFlowFinancing;

  %%%%%%%%%%%%%Growth Estimations%%%%%%%%%%%%%%

  V_EstimatedRevenueGrowthRate = sqrt(((I_TTMRevenue/I_T_1YearRevenue)-1)*((I_T_1YearRevenue/I_T_2YearRevenue)-1));
  V_EstimatedIncomeGrowthRate = sqrt(((I_TTMNetIncome/I_T_1YearNetIncome)-1)*((I_T_1YearNetIncome/I_T_2YearNetIncome)-1));
  %Assume Cash flow grows with the same rate as Income.
  V_EstimatedCashFlowGrowthRate = V_EstimatedIncomeGrowthRate; 

  %%%%%%%%%%%%%Past Period%%%%%%%%%%%%%%
  PastTimeLine = -P_PastYearsRecoreded:0;
  %Revenue%

  V_PastRevenueSeries = zeros(1, P_PastYearsRecoreded + 1);
  V_PastRevenueSeries(1) = I_T_2YearNetIncome;
  V_PastRevenueSeries(2) = I_T_1YearNetIncome;
  V_PastRevenueSeries(3) = I_TTMNetIncome;
  
  V_PastRevenueGrowthRateSeries = zeros(1, P_PastYearsRecoreded + 1);
  V_PastRevenueGrowthRateSeries(:) = V_EstimatedRevenueGrowthRate;
  
  %Income%

  V_PastCashFlowSeries = zeros(1, P_PastYearsRecoreded + 1);
  V_PastCashFlowSeries(1) = I_T_2YearNetIncome;
  V_PastCashFlowSeries(2) = I_T_1YearNetIncome;
  V_PastCashFlowSeries(3) = I_TTMNetIncome;
  
  V_PastCashFlowGrowthRateSeries = zeros(1, P_PastYearsRecoreded + 1);
  V_PastCashFlowGrowthRateSeries(:) = V_EstimatedCashFlowGrowthRate;

  %%%%%%%%%%%%%Growth Period%%%%%%%%%%%%%%  
  
  
  GrowthPeriodTimeLine = 0:P_NumOfGrowthYears;
  V_GrowthCashFlowSeries = zeros(1, P_NumOfGrowthYears + 1);
  V_GrowthCashFlowSeries(1) = V_PastCashFlowSeries(end);  

  V_GrowthPeriodGrowthRateSeries = zeros(1, P_NumOfGrowthYears + 1);
  V_GrowthPeriodGrowthRateSeries(:) = V_EstimatedCashFlowGrowthRate ;
  
  for n = 2:length(V_GrowthCashFlowSeries)
    V_GrowthCashFlowSeries(n) =(V_GrowthCashFlowSeries(n-1)*(1+V_GrowthPeriodGrowthRateSeries(n)));
  end

  %%%%%%%%%%%%%WindDown Period%%%%%%%%%%%%%%  
  WindDownPeriodTimeLine = P_NumOfGrowthYears:P_NumOfGrowthYears + P_NumOfWindDownYears;
  V_WindDownCashFlowSeries = zeros(1, P_NumOfWindDownYears + 1);
  V_WindDownCashFlowSeries(1) = V_GrowthCashFlowSeries(end);  

  V_WindDownPeriodGrowthRateSeries = zeros(1, P_NumOfWindDownYears + 1);
  YearlyDropInGrowth = (V_EstimatedCashFlowGrowthRate - P_TerminalGrowthRate)/P_NumOfWindDownYears
  V_WindDownPeriodGrowthRateSeries(:) =  V_EstimatedCashFlowGrowthRate: - YearlyDropInGrowth: P_TerminalGrowthRate
  
  for n = 2:length(V_GrowthCashFlowSeries)
    V_WindDownCashFlowSeries(n) =(V_WindDownCashFlowSeries(n-1)*(1+V_WindDownPeriodGrowthRateSeries(n)));
  end

  %%%%%%%%%%%%%Terminal Period%%%%%%%%%%%%%%  
  TerminalPeriodTimeLine = P_NumOfWindDownYears+P_NumOfGrowthYears:P_PlotPeriod;
  V_TerminalCashFlowSeries = zeros(1, P_PlotPeriod - P_NumOfGrowthYears - P_NumOfWindDownYears + 1);
  V_TerminalCashFlowSeries(1) = V_WindDownCashFlowSeries(end);

  V_TerminalPeriodGrowthRateSeries = zeros(1, P_PlotPeriod - P_NumOfGrowthYears - P_NumOfWindDownYears + 1);
  V_TerminalPeriodGrowthRateSeries(:) = P_TerminalGrowthRate ;

  for n = 2:length(V_TerminalCashFlowSeries)
    V_TerminalCashFlowSeries(n) =(V_TerminalCashFlowSeries(n-1)*(1+V_TerminalPeriodGrowthRateSeries(n)));
  end

  
  %%%%%%%%%%%%%Plotting%%%%%%%%%%%%%%  

  subplot(1,2,1);  
  plot(PastTimeLine, V_PastCashFlowSeries, ";Past Cash Flow;", "marker", '+', "linewidth", 5, 
  GrowthPeriodTimeLine, V_GrowthCashFlowSeries, ";Projected Growth Period Cash Flow;", "marker", '+', "linewidth", 5, "linestyle", ":",
  WindDownPeriodTimeLine, V_WindDownCashFlowSeries, ";Projected Wind Down Period Cash Flow;", "marker", '+', "linewidth", 5, "linestyle", ":",
  TerminalPeriodTimeLine, V_TerminalCashFlowSeries, ";Projected Terminal Growth Cash Flow;", "marker", '+', "linewidth", 5, "linestyle", "-."
  );
  xlabel ("Years");
  ylabel ("Egp");

  subplot(1,2,2);  
  plot(  PastTimeLine, V_PastCashFlowGrowthRateSeries * 100, ";Past Growth Rate;", "marker", '+', "linewidth", 5,
  GrowthPeriodTimeLine, V_GrowthPeriodGrowthRateSeries * 100, ";Projected Growth Period Growth Rate;", "marker", '+', "linewidth", 5, "linestyle", ":",
  WindDownPeriodTimeLine, V_WindDownPeriodGrowthRateSeries * 100, ";Projected Wind Down Period Growth Rate;", "marker", '+', "linewidth", 5, "linestyle", ":",
  TerminalPeriodTimeLine, V_TerminalPeriodGrowthRateSeries * 100, ";Projected Terminal Period Growth Rate;", "marker", '+', "linewidth", 5, "linestyle", "-."
  );
  xlabel ("Years");
  ylabel ("%");

  
endfunction
