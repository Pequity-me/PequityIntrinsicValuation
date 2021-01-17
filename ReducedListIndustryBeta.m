function UnLeveredBeta = ReducedListIndustryBeta (Industry)
  
  if(Industry == "Advertising")
     UnLeveredBeta = 0.83;
  elseif(Industry == "Apparel")
     UnLeveredBeta = 0.83;
  elseif(Industry == "Auto & Truck")
     UnLeveredBeta = 0.56;
  elseif(Industry == "Auto Parts")
     UnLeveredBeta = 0.99;
  elseif(Industry == "Banks (Regional)")
     UnLeveredBeta = 0.42;
  elseif(Industry == "Beverage")
     UnLeveredBeta = 0.87;
  elseif(Industry == "Broadcasting")
     UnLeveredBeta = 0.67;
  elseif(Industry == "Brokerage & Investment Banking")
     UnLeveredBeta = 0.5;
  elseif(Industry == "Building Materials")
     UnLeveredBeta = 0.96;
  elseif(Industry == "Business & Consumer Services")
     UnLeveredBeta = 0.92;
  elseif(Industry == "Chemical")
     UnLeveredBeta = 0.89;
  elseif(Industry == "Coal & Related Energy")
     UnLeveredBeta = 0.77;
  elseif(Industry == "Computer Services")
     UnLeveredBeta = 0.95;
  elseif(Industry == "Computers/Peripherals")
     UnLeveredBeta = 1.23;
  elseif(Industry == "Construction Supplies")
     UnLeveredBeta = 1.05;
  elseif(Industry == "Drugs (Pharmaceutical)")
     UnLeveredBeta = 1.08;
  elseif(Industry == "Education")
     UnLeveredBeta = 1.07;
  elseif(Industry == "Electrical Equipment")
     UnLeveredBeta = 1.1;
  elseif(Industry == "Electronics")
     UnLeveredBeta = 0.93;
  elseif(Industry == "Engineering/Construction")
     UnLeveredBeta = 1.05;
  elseif(Industry == "Entertainment")
     UnLeveredBeta = 1.03;
  elseif(Industry == "Environmental & Waste Services")
     UnLeveredBeta = 0.83;
  elseif(Industry == "Farming/Agriculture")
     UnLeveredBeta = 0.63;
  elseif(Industry == "Financial Svcs. (Non-bank & Insurance")
     UnLeveredBeta = 0.08;
  elseif(Industry == "Food Processing")
     UnLeveredBeta = 0.63;
  elseif(Industry == "Food Wholesalers")
     UnLeveredBeta = 0.94;
  elseif(Industry == "Furn/Home Furnishings")
     UnLeveredBeta = 0.77;
  elseif(Industry == "Green & Renewable Energy")
     UnLeveredBeta = 0.68;
  elseif(Industry == "Healthcare Products")
     UnLeveredBeta = 0.92;
  elseif(Industry == "Healthcare Support Services")
     UnLeveredBeta = 0.87;
  elseif(Industry == "Homebuilding")
     UnLeveredBeta = 0.86;
  elseif(Industry == "Hospitals/Healthcare Facilities")
     UnLeveredBeta = 0.56;
  elseif(Industry == "Hotels")
     UnLeveredBeta = 0.82;
  elseif(Industry == "Household Products")
     UnLeveredBeta = 0.85;
  elseif(Industry == "Information Services")
     UnLeveredBeta = 0.94;
  elseif(Industry == "Insurance (General)")
     UnLeveredBeta = 0.66;
  elseif(Industry == "Investments & Asset Management")
     UnLeveredBeta = 0.81;
  elseif(Industry == "Machinery")
     UnLeveredBeta = 1.04;
  elseif(Industry == "Metals & Mining")
     UnLeveredBeta = 0.96;
  elseif(Industry == "Office Equipment & Services")
     UnLeveredBeta = 1.15;
  elseif(Industry == "Oil/Gas Distribution")
     UnLeveredBeta = 0.65;
  elseif(Industry == "Packaging & Container")
     UnLeveredBeta = 0.69;
  elseif(Industry == "Paper Products")
     UnLeveredBeta = 1.01;
  elseif(Industry == "Precious Metals")
     UnLeveredBeta = 1.05;
  elseif(Industry == "Publishing & Newspapers")
     UnLeveredBeta = 0.94;
  elseif(Industry == "R.E.I.T.")
     UnLeveredBeta = 0.48;
  elseif(Industry == "Real Estate (Development)")
     UnLeveredBeta = 0.72;
  elseif(Industry == "Real Estate (General/Diversified)")
     UnLeveredBeta = 1.07;
  elseif(Industry == "Real Estate (Operations & Services)")
     UnLeveredBeta = 0.8;
  elseif(Industry == "Recreation")
     UnLeveredBeta = 0.76;
  elseif(Industry == "Restaurant/Dining")
     UnLeveredBeta = 0.74;
  elseif(Industry == "Retail (Automotive)")
     UnLeveredBeta = 0.77;
  elseif(Industry == "Retail (Building Supply)")
     UnLeveredBeta = 1.12;
  elseif(Industry == "Retail (Distributors)")
     UnLeveredBeta = 0.85;
  elseif(Industry == "Retail (General)")
     UnLeveredBeta = 0.86;
  elseif(Industry == "Retail (Grocery and Food)")
     UnLeveredBeta = 0.41;
  elseif(Industry == "Retail (Online)")
     UnLeveredBeta = 1.24;
  elseif(Industry == "Rubber& Tires")
     UnLeveredBeta = 0.66;
  elseif(Industry == "Semiconductor")
     UnLeveredBeta = 1.17;
  elseif(Industry == "Shipbuilding & Marine")
     UnLeveredBeta = 0.97;
  elseif(Industry == "Shoe")
     UnLeveredBeta = 0.84;
  elseif(Industry == "Software (Entertainment)")
     UnLeveredBeta = 1.14;
  elseif(Industry == "Software (Internet)")
     UnLeveredBeta = 1.2;
  elseif(Industry == "Software (System & Application)")
     UnLeveredBeta = 1.08;
  elseif(Industry == "Steel")
     UnLeveredBeta = 1.16;
  elseif(Industry == "Telecom Services")
     UnLeveredBeta = 0.63;
  elseif(Industry == "Transportation")
     UnLeveredBeta = 0.91;
  elseif(Industry == "Trucking")
     UnLeveredBeta = 0.88;
  elseif(Industry == "Utility (General)")
     UnLeveredBeta = 0.28;
  else
    error("Invliad Industry");
  endif
  
  endfunction