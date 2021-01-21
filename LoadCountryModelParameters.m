%http://pages.stern.nyu.edu/~adamodar/New_Home_Page/datafile/ctryprem.html

P_NumOfGrowthYears = 5;
P_NumOfWindDownYears = 5;
P_10YearUSGvmtBondYield = 0.0112;

if(strcmp(I_Country,"Algeria"))
  P_10YearCountryGvmtBondYield = 0.0575;
  P_10YearCountryGvmtBondYieldUSD = 0.088;
  P_CountryCorporateTaxRate = 0.26;
  P_CostOfDebt = 0.08;

elseif(strcmp(I_Country,"Brazil"))
  P_10YearCountryGvmtBondYield = 0.07486;
  P_10YearCountryGvmtBondYieldUSD = 0.0403;
  P_CountryCorporateTaxRate = 0.34;
  P_CostOfDebt = 0.38;

elseif(strcmp(I_Country,"China"))
  P_10YearCountryGvmtBondYield = 0.03148;
  P_10YearCountryGvmtBondYieldUSD = 0.018;
  P_CountryCorporateTaxRate = 0.25;
  P_CostOfDebt = 0.04350;

elseif(strcmp(I_Country,"Egypt"))
  P_10YearCountryGvmtBondYield = 0.148;
  P_10YearCountryGvmtBondYieldUSD = 0.0645;
  P_CountryCorporateTaxRate = 0.225;
  P_CostOfDebt = 0.098;

elseif(strcmp(I_Country,"India"))
  P_10YearCountryGvmtBondYield = 0.05936;
  P_10YearCountryGvmtBondYieldUSD = 0.0325;
  P_CountryCorporateTaxRate = 0.25;
  P_CostOfDebt = 0.088;

elseif(strcmp(I_Country,"Indonesia"))
  P_10YearCountryGvmtBondYield = 0.06212;
  P_10YearCountryGvmtBondYieldUSD = 0.0296;
  P_CountryCorporateTaxRate = 0.15;
  P_CostOfDebt = 0.045;

elseif(strcmp(I_Country,"Nigeria"))
  P_10YearCountryGvmtBondYield = 0.08353;
  P_10YearCountryGvmtBondYieldUSD = 0.0645;
  P_CountryCorporateTaxRate = 0.3;
  P_CostOfDebt = 0.116;

elseif(strcmp(I_Country,"Pakistan"))
  P_10YearCountryGvmtBondYield = 0.010287;
  P_10YearCountryGvmtBondYieldUSD = 0.0742;
  P_CountryCorporateTaxRate = 0.29;
  P_CostOfDebt = 0.1223;
  
elseif(strcmp(I_Country,"Russia"))
  P_10YearCountryGvmtBondYield = 0.06120;
  P_10YearCountryGvmtBondYieldUSD = 0.0325;
  P_CountryCorporateTaxRate = 0.2;
  P_CostOfDebt = 0.06;

elseif(strcmp(I_Country,"SaudiArabia"))
  P_10YearCountryGvmtBondYield = 0.0225;
  P_10YearCountryGvmtBondYieldUSD = 0.0275;
  P_CountryCorporateTaxRate = 0.2;
  P_CostOfDebt = 0.01;

elseif(strcmp(I_Country,"Turkey"))
  P_10YearCountryGvmtBondYield = 0.13;
  P_10YearCountryGvmtBondYieldUSD = 0.0645;
  P_CountryCorporateTaxRate = 0.22;
  P_CostOfDebt = 0.15;

elseif(strcmp(I_Country,"UAE"))
  P_10YearCountryGvmtBondYield = 0.0471;
  P_10YearCountryGvmtBondYieldUSD = 0.0317;
  P_CountryCorporateTaxRate = 0;
  P_CostOfDebt = 0.015;
  
elseif(strcmp(I_Country,"Uk"))
  P_10YearCountryGvmtBondYield = 0.0475;
  P_10YearCountryGvmtBondYieldUSD = 0.0171;
  P_CountryCorporateTaxRate = 0.19;
  P_CostOfDebt = 0.011;
    
elseif(strcmp(I_Country,"USA"))
  P_10YearCountryGvmtBondYield = 0.0112;
  P_10YearCountryGvmtBondYieldUSD = 0.0112;
  P_CountryCorporateTaxRate = 0.21;
  P_CostOfDebt = 0.0325;
  
endif
