# PequityIntrinsicValuation
A matlab model to calculate valuation of a business based on free cash flow analysis

## Usage
Install matlab and octave then run the `TestBench.m` which provides a sample usage of the valuation model using different input parameteres.
```
[O_EnterpriseValueLow, O_EnterpriseValueHigh, ...
          O_ProjectedRevenueSeries, O_ProjectedVariableCostSeries, O_ProjectedCashFlowSeries,...
          O_PlotPeriod, O_ErrorCode]... 
= RunValuation (I_Country, I_Industry, I_Debt, I_NonCashAssets, I_Cash,
  I_YearlyFixedCost,
  I_YearlyFinancialEntries[0].Revenue, I_YearlyFinancialEntries[0].CashFlow, 
  I_YearlyFinancialEntries[1].Revenue, I_YearlyFinancialEntries[1].CashFlow, 
  ...);
  ```
The model was used as a backend in combination with a REST API component [pequity-rest](https://github.com/Pequity-me/pequity-rest) for pequity marketplace and valuation app, but it doesn't depend on the REST API and can be executed locally in a standard matlab/octave environment .

A nice tutorial to use the input parameters (unfortunately in arabic only) can be found [here](https://www.facebook.com/pequity/posts/pfbid02CndbWjaCzaNFiFiJP9n7oVrKM6HBhJnUzxURNmF6HsxAb9U16TN1VvfctKVF9Uhql). Facebook translation should be helpful, otherwise the paramters are explanatory : inputs start with `I_` and outputs with `O_`. When executing the `RunValuation()` function the outputs will be populated in addition to graphs plotting the outputs. 



## Limitations
Only the countries listed in `LoadCountryModelParameters.m` are supported, however the model can be extended easily by adding a new entry to the desired country.

## Contribution
Fork and raise pull requests
  
