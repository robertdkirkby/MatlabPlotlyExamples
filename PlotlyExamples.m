
%% Example 1
StartDate='1960-01-01';
EndDate='2014-12-31';

% Real Gross Domestic Product (Billions of Chained 2009 Dollars, Quarterly, Seasonally Adjusted Annual Rate)
fred_GDP = getFredData('GDPC1', StartDate, EndDate)
% Real Potential Gross Domestic Product (Billions of Chained 2009 Dollars, Quarterly, Not Seasonally Adjusted)
fred_PotentialGDP = getFredData('GDPPOT', StartDate, EndDate)

trace1= struct('x', {cellstr(datestr(fred_GDP.Data(:,1),'yyyy-QQ'))},'y',fred_GDP.Data(:,2),'name', 'Potential GDP','type', 'scatter','marker',struct('size',1));
trace2= struct('x', {cellstr(datestr(fred_PotentialGDP.Data(:,1),'yyyy-QQ'))},'y',fred_PotentialGDP.Data(:,2),'name', 'Potential GDP','type', 'scatter','marker',struct('size',1));
data = {trace1,trace2};
layout = struct('title', 'US Real GDP and Potential Real GDP','showlegend', true,'width', 800,...
    'xaxis', struct('domain', [0, 0.9],'title','Year'), ...
    'yaxis', struct('title', fred_PotentialGDP.Units(:),'titlefont', struct('color', 'black'),'tickfont', struct('color', 'black'),'anchor', 'free','side', 'left','position',0) );
response = plotly(data, struct('layout', layout, 'filename', 'PotentialGDP_US', 'fileopt', 'overwrite'));
response.data=data; response.layout=layout;
saveplotlyfig(response, 'PotentialGDP_US.pdf')

%% Example 2
% USA
% Unemployment Rate: Aged 15 and Over: All Persons for Spain (Percent, Quarterly, Seasonally Adjusted)
fred_US_Unemp = getFredData('LRUNTTTTUSQ156S', StartDate, EndDate)
% Gross Domestic Product by Expenditure in Constant Prices: Total Gross Domestic Product for Spain (Chained 2000 National Currency Units, Quarterly, Seasonally Adjusted)
fred_US_GDPgrowth = getFredData('NAEXKP01USQ652S', StartDate, EndDate,'pc1')
% Now draw the graph putting each series on a different y-axis
trace1= struct('x', {cellstr(datestr(fred_US_Unemp.Data(:,1),'yyyy-QQ'))},'y',fred_US_Unemp.Data(:,2),'name', 'Unemployment Rate (left)','type', 'scatter','line', struct('color', 'hsv(0,80,100)'));
trace2= struct('x', {cellstr(datestr(fred_US_GDPgrowth.Data(:,1),'yyyy-QQ'))},'y',fred_US_GDPgrowth.Data(:,2),'name', 'Growth Rate of Real GDP (right)','type', 'scatter','yaxis','y2','line',struct('color','hsv(210,80,100)'));
data = {trace1,trace2};
layout = struct('title', 'Output and Unemployment in USA','showlegend', true,'width', 800,...
    'xaxis', struct('title','Year','showgrid',false,'anchor','y2','tickangle',-45,'nticks',20),...
    'yaxis', struct('title', 'Percent','titlefont', struct('color', 'black'),'tickfont', struct('color', 'black'),'position',0,'anchor', 'free','showgrid',false),...
    'yaxis2', struct('title','Percentage Change on Year Ago','titlefont', struct('color', 'black'),'tickfont', struct('color', 'black'),'overlaying','y','position',1,'side','right','anchor', 'free','showgrid',false) );%, ...
response = plotly(data, struct('layout', layout, 'filename', 'US_GDPgrowth_Unemp', 'fileopt', 'overwrite'));
response.data=data; response.layout=layout;
saveplotlyfig(response, './Graphs/US_GDPgrowth_Unemp.pdf')

%% Example 3
% Real Gross Domestic Product (Percent Change from Quarter One Year Ago, Quarterly, Seasonally Adjusted)
fred_GDPg = getFredData('A191RO1Q156NBEA', '1990-01-01', '2014-12-31')
% Effective Federal Funds Rate (Percent, Monthly, Not Seasonally Adjusted)
fred_FEDFUNDS = getFredData('FEDFUNDS', '1990-01-01', '2014-12-31','lin','q','avg')

trace1= struct('x', {cellstr(datestr(fred_GDPg.Data(:,1),'yyyy-QQ'))},'y',fred_GDPg.Data(:,2),'name', 'GDP Growth','type', 'scatter','line', struct('color', 'hsv(0,80,100)'));
trace2= struct('x', {cellstr(datestr(fred_FEDFUNDS.Data(:,1),'yyyy-QQ'))},'y',fred_FEDFUNDS.Data(:,2),'name', 'Fed Funds (right)','type', 'scatter','yaxis','y2','line', struct('color', 'hsv(210,80,100)'));
data = {trace1,trace2};
layout = struct('title', 'US: Real GDP Growth and Federal Funds Rate','showlegend', true,'width', 800,...
'xaxis', struct('title','Year','domain',[0.1,1],'showgrid',false,'anchor','y2','tickangle',-45,'nticks',20),...
    'yaxis', struct('title', fred_GDPg.Units(:),'titlefont', struct('color', 'hsv(0,80,100)'),'tickfont', struct('color', 'hsv(0,80,100)'),'position',0,'anchor', 'free','showgrid',false,'zeroline',false),...
    'yaxis2', struct('title','Percent (Average of Daily Rates)','titlefont', struct('color', 'hsv(210,80,100)'),'tickfont', struct('color', 'hsv(210,80,100)'),'position',0.03,'overlaying','y','anchor', 'free','showgrid',false,'zeroline',false),...
    'legend',struct('x',0.05,'y',0.1));
response = plotly(data, struct('layout', layout, 'filename', 'GDPandFedFunds', 'fileopt', 'overwrite'));
response.data=data; response.layout=layout;
saveplotlyfig(response, './Graphs/GDPandFedFunds.pdf')

% House Prices
StartDate='1990-01-01'
EndDate='2014-12-31'
index2000=41;

% S&P/Case-Shiller 20-City Composite Home Price Index (Index Jan 2000=100, Monthly, Seasonally Adjusted)
fred_HousePrices_CaseShiller = getFredData('SPCS20RSA', StartDate, EndDate)
% S&P Case-Shiller 20-City Home Price Sales Pair Counts (Units, Monthly, Not Seasonally Adjusted)
fred_HouseSales_CaseShiller = getFredData('SPCS20RPSNSA', StartDate, EndDate)
% All-Transactions House Price Index for the United States (Index 1980:Q1=100, Quarterly, Not Seasonally Adjusted)
fred_HousePrices_FHFA = getFredData('USSTHPI', StartDate, EndDate) %FHFA=Federal Housing Finance Agency

% Trick to putting the monthly and quarterly data on same graph is a hidden second x-axis which has a different frequency
trace1= struct('x', fred_HousePrices_FHFA.Data(:,1),'y',100*fred_HousePrices_FHFA.Data(:,2)./fred_HousePrices_FHFA.Data(index2000,2),'name', 'House Prices (FHFA)','type', 'scatter','yaxis','y1','xaxis','x2');
trace1dates= struct('x', {cellstr(datestr(fred_HousePrices_FHFA.Data(:,1),'yyyy-QQ'))},'y',100*fred_HousePrices_FHFA.Data(:,2)./fred_HousePrices_FHFA.Data(index2000,2),'name', 'House Prices (FHFA)','type', 'scatter','yaxis','y1','xaxis','x1','showlegend',false);
trace2= struct('x', fred_HousePrices_CaseShiller.Data(:,1),'y',fred_HousePrices_CaseShiller.Data(:,2),'name', 'House Price Index (Case-Shiller)','type', 'scatter','yaxis', 'y1','xaxis','x2');
trace3= struct('x', fred_HouseSales_CaseShiller.Data(:,1),'y',fred_HouseSales_CaseShiller.Data(:,2),'name', 'House Sales (Case-Shiller; right-axis)','type', 'scatter','yaxis', 'y2','xaxis','x2','line', struct('dash', 'dot'));
data = {trace1dates,trace2,trace3,trace1};
layout = struct('title', 'US House Prices and the Great Recession','showlegend', true,'width', 800,...
    'xaxis', struct('domain', [0, 1],'title','Year'), ...
    'xaxis2', struct('domain', [0, 1],'showgrid',false,'ticks','','showticklabels',false,'showline',0), ...
    'legend', struct('x',0.05,'y',0.9),...
    'yaxis', struct('title', 'Index (2000==1)','titlefont', struct('color', 'black'),'tickfont', struct('color', 'black'),'anchor', 'free','side', 'left','position',0), ...
    'yaxis2', struct('title', 'Units','titlefont', struct('color', 'black'),'tickfont', struct('color', 'black'),'anchor', 'free','side', 'right','position',1,'overlaying','y1','showgrid',false) );%, ...
response = plotly(data, struct('layout', layout, 'filename', 'GreatRecession_HousePrices_US', 'fileopt', 'overwrite'));
response.data=data; response.layout=layout;
saveplotlyfig(response, './Graphs/GreatRecession_HousePrices_US.pdf')

%% Example 4
% There is none

%% Example 5
% First, just get the graph of GDP growth
GDPgrowth=getFredData('GDPCA', '2007-01-01', '2014-12-31','pc1');

% Now, get the forecasts from each year for the next two years
ForecastGDPgrowth=nan(2,2,8);
FourthQuarterGDP=nan(10,2);
FourthQuarterGDPForecasts=nan(3,2,8);
temp2=getFredData('GDPC1', '2005-12-31', '2005-12-31');
FourthQuarterGDP(1,:)=temp2.Data;
temp2=getFredData('GDPC1', '2006-12-31', '2006-12-31');
FourthQuarterGDP(2,:)=temp2.Data;

for t=2007:2014
    ondate=[num2str(t),'-12-31'];
    nextyear=[num2str(t+1),'-07-01'];
    next2year=[num2str(t+2),'-07-01'];
    % FOMC Summary of Economic Projections for the Growth Rate of Real Gross Domestic Product, Central Tendency, Midpoint
    %(Fourth Quarter to Fourth Quarter Percent Change, Annual, Not Seasonally Adjusted)
    temp=getFredData('GDPC1CTM', nextyear, next2year, [], [],[], ondate);
    ForecastGDPgrowth(:,:,t-2006)=temp.Data;
    temp2=getFredData('GDPC1', ondate, ondate);
    FourthQuarterGDP(t-2006+2,:)=temp2.Data;
    
    FourthQuarterGDPForecasts(1,:,t-2006)=temp2.Data;
    FourthQuarterGDPForecasts(2:3,1,t-2006)=temp.Data(:,1);
    FourthQuarterGDPForecasts(2,2,t-2006)=temp2.Data(1,2)*(1+temp.Data(1,2)/100);
    FourthQuarterGDPForecasts(3,2,t-2006)=temp2.Data(1,2)*(1+temp.Data(1,2)/100)*(1+temp.Data(2,2)/100);
end

% Graph of the growth rate forecasts
trace1= struct('x', {cellstr(datestr(GDPgrowth.Data(:,1),'yyyy'))},'y',GDPgrowth.Data(:,2),'name', 'Actual GDP growth','type', 'scatter','marker',struct('size',1));
trace2= struct('x', {cellstr(datestr(ForecastGDPgrowth(:,1,1),'yyyy'))},'y',ForecastGDPgrowth(:,2,1),'name', '2007 Forecast','type', 'scatter','marker',struct('size',1));
trace3= struct('x', {cellstr(datestr(ForecastGDPgrowth(:,1,2),'yyyy'))},'y',ForecastGDPgrowth(:,2,2),'name', '2008 Forecast','type', 'scatter','marker',struct('size',1));
trace4= struct('x', {cellstr(datestr(ForecastGDPgrowth(:,1,3),'yyyy'))},'y',ForecastGDPgrowth(:,2,3),'name', '2009 Forecast','type', 'scatter','marker',struct('size',1));
trace5= struct('x', {cellstr(datestr(ForecastGDPgrowth(:,1,4),'yyyy'))},'y',ForecastGDPgrowth(:,2,4),'name', '2010 Forecast','type', 'scatter','marker',struct('size',1));
trace6= struct('x', {cellstr(datestr(ForecastGDPgrowth(:,1,5),'yyyy'))},'y',ForecastGDPgrowth(:,2,5),'name', '2011 Forecast','type', 'scatter','marker',struct('size',1));
trace7= struct('x', {cellstr(datestr(ForecastGDPgrowth(:,1,6),'yyyy'))},'y',ForecastGDPgrowth(:,2,6),'name', '2012 Forecast','type', 'scatter','marker',struct('size',1));
data = {trace1,trace2,trace3,trace4,trace5,trace6,trace7};
layout = struct('title', 'Recognition Lags: US GDP growth Forecasts in Great Recession','showlegend', true,'width', 800,...
    'xaxis', struct('domain', [0, 0.9],'title','Year'), ...
    'yaxis', struct('title', 'Percent', 'anchor', 'free','side', 'left','position',0) );
response = plotly(data, struct('layout', layout, 'filename', 'GreatRecession_GDPgrowthForecasts', 'fileopt', 'overwrite'));
response.data=data; response.layout=layout;
% Graph has been created let's save a pdf copy to inside a folder called Graphs (folder must already exist or matlab will error)
saveplotlyfig(response, './Graphs/GreatRecession_GDPgrowthForecasts.pdf')

% Graph of the implicit level forecasts
trace1= struct('x', {cellstr(datestr(FourthQuarterGDP(:,1),'yyyy'))},'y',FourthQuarterGDP(:,2),'name', 'Actual GDP','type', 'scatter','marker',struct('size',1));
trace2= struct('x', {cellstr(datestr(FourthQuarterGDPForecasts(:,1,1),'yyyy'))},'y',FourthQuarterGDPForecasts(:,2,1),'name', '2007 Forecast','type', 'scatter','opacity',0.8,'marker',struct('size',1),'line',struct('dash','dot'));
trace3= struct('x', {cellstr(datestr(FourthQuarterGDPForecasts(:,1,2),'yyyy'))},'y',FourthQuarterGDPForecasts(:,2,2),'name', '2008 Forecast','type', 'scatter','opacity',0.8,'marker',struct('size',1),'line',struct('dash','dot'));
trace4= struct('x', {cellstr(datestr(FourthQuarterGDPForecasts(:,1,3),'yyyy'))},'y',FourthQuarterGDPForecasts(:,2,3),'name', '2009 Forecast','type', 'scatter','opacity',0.8,'marker',struct('size',1),'line',struct('dash','dot'));
trace5= struct('x', {cellstr(datestr(FourthQuarterGDPForecasts(:,1,4),'yyyy'))},'y',FourthQuarterGDPForecasts(:,2,4),'name', '2010 Forecast','type', 'scatter','opacity',0.8,'marker',struct('size',1),'line',struct('dash','dot'));
trace6= struct('x', {cellstr(datestr(FourthQuarterGDPForecasts(:,1,5),'yyyy'))},'y',FourthQuarterGDPForecasts(:,2,5),'name', '2011 Forecast','type', 'scatter','opacity',0.8,'marker',struct('size',1),'line',struct('dash','dot'));
trace7= struct('x', {cellstr(datestr(FourthQuarterGDPForecasts(:,1,6),'yyyy'))},'y',FourthQuarterGDPForecasts(:,2,6),'name', '2012 Forecast','type', 'scatter','opacity',0.8,'marker',struct('size',1),'line',struct('dash','dot'));
data = {trace1,trace2,trace3,trace4,trace5,trace6,trace7};
layout = struct('title', 'Recognition Lags: US GDP Forecasts in Great Recession','showlegend', true,'width', 800,...
    'xaxis', struct('domain', [0, 0.9],'title','Year','showgrid',false), ...
    'yaxis', struct('title', temp2.Units(:),'anchor', 'free','side', 'left','position',0,'showgrid',false) );
response = plotly(data, struct('layout', layout, 'filename', 'GreatRecession_ImplicitGDPlevelForecasts', 'fileopt', 'overwrite'));
response.data=data; response.layout=layout;
% Graph has been created let's save a pdf copy to inside a folder called Graphs (folder must already exist or matlab will error)
saveplotlyfig(response, './Graphs/GreatRecession_ImplicitGDPlevelForecasts.pdf')

% This example is more complicated as it uses structures to store the data rather than matrices (useful here as the different series are different lengths)
% Real Gross Domestic Product (Billions of Chained 2009 Dollars, Quarterly, Seasonally Adjusted Annual Rate)
fred_GDP = getFredData('GDPC1', '2005-12-31', '2014-12-31')
% Real Potential Gross Domestic Product (Billions of Chained 2009 Dollars, Quarterly, Not Seasonally Adjusted)
fred_PotentialGDP = getFredData('GDPPOT', '2005-12-31', '2014-12-31')

for t=2007:2014
ti=t-2006;
ondate=[num2str(t),'-12-31'];
    % FOMC Summary of Economic Projections for the Growth Rate of Real Gross Domestic Product, Central Tendency, Midpoint
    % (Fourth Quarter to Fourth Quarter Percent Change, Annual, Not Seasonally Adjusted)
    ForecastPotentialGDP(ti)=getFredData('GDPPOT', ondate, '2014-12-31', [], [],[], ondate);
    [~,FindDateIndex]=min(abs(fred_PotentialGDP.Data(:,1)-datenum(ForecastPotentialGDP(ti).Data(1,1))));
    ForecastPotentialGDP(ti).Data(:,2)=ForecastPotentialGDP(ti).Data(:,2)*(fred_PotentialGDP.Data(FindDateIndex,2)/ForecastPotentialGDP(ti).Data(1,2));
    % Note that just reindexing using the GDP Deflator doesn't work. There is more to the revisions than this. (Possibly/probably due to revised versus
    % realtime GDP data; including changes in measurement of GDP, things like the recent switch to include measurement of Intangibles in GDP.)
    % The approach I use here is based on assumption that original forecast was really about how fast potential gdp would grow in the future. It will
    % be accurate in as far as this is true. If change in level would have led to change in prediction then approach I use would be biased.
end

% Now draw the graph
trace1= struct('x', {cellstr(datestr(fred_GDP.Data(:,1),'yyyy-QQ'))},'y',fred_GDP.Data(:,2),'name', 'Real GDP','type', 'scatter','marker',struct('size',1));
trace2= struct('x', {cellstr(datestr(fred_PotentialGDP.Data(:,1),'yyyy-QQ'))},'y',fred_PotentialGDP.Data(:,2),'name', 'Potential Real GDP','type', 'scatter','marker',struct('size',1));
trace3= struct('x', {cellstr(datestr(ForecastPotentialGDP(1).Data(:,1),'yyyy-QQ'))},'y',ForecastPotentialGDP(1).Data(:,2),'name', '2007 Forecast','type', 'scatter','opacity',0.8,'marker',struct('size',1),'line',struct('dash','dot'));
trace4= struct('x', {cellstr(datestr(ForecastPotentialGDP(2).Data(:,1),'yyyy-QQ'))},'y',ForecastPotentialGDP(2).Data(:,2),'name', '2008 Forecast','type', 'scatter','opacity',0.8,'marker',struct('size',1),'line',struct('dash','dot'));
trace5= struct('x', {cellstr(datestr(ForecastPotentialGDP(3).Data(:,1),'yyyy-QQ'))},'y',ForecastPotentialGDP(3).Data(:,2),'name', '2009 Forecast','type', 'scatter','opacity',0.8,'marker',struct('size',1),'line',struct('dash','dot'));
trace6= struct('x', {cellstr(datestr(ForecastPotentialGDP(4).Data(:,1),'yyyy-QQ'))},'y',ForecastPotentialGDP(4).Data(:,2),'name', '2010 Forecast','type', 'scatter','opacity',0.8,'marker',struct('size',1),'line',struct('dash','dot'));
trace7= struct('x', {cellstr(datestr(ForecastPotentialGDP(5).Data(:,1),'yyyy-QQ'))},'y',ForecastPotentialGDP(5).Data(:,2),'name', '2011 Forecast','type', 'scatter','opacity',0.8,'marker',struct('size',1),'line',struct('dash','dot'));
trace8= struct('x', {cellstr(datestr(ForecastPotentialGDP(6).Data(:,1),'yyyy-QQ'))},'y',ForecastPotentialGDP(6).Data(:,2),'name', '2012 Forecast','type', 'scatter','opacity',0.8,'marker',struct('size',1),'line',struct('dash','dot'));
trace9= struct('x', {cellstr(datestr(ForecastPotentialGDP(7).Data(:,1),'yyyy-QQ'))},'y',ForecastPotentialGDP(7).Data(:,2),'name', '2013 Forecast','type', 'scatter','opacity',0.8,'marker',struct('size',1),'line',struct('dash','dot'));
trace10= struct('x', {cellstr(datestr(ForecastPotentialGDP(8).Data(:,1),'yyyy-QQ'))},'y',ForecastPotentialGDP(8).Data(:,2),'name', '2014 Forecast','type', 'scatter','opacity',0.8,'marker',struct('size',1),'line',struct('dash','dot'));
data = {trace1,trace2,trace3,trace4,trace5,trace6,trace7,trace8,trace9,trace10};
layout = struct('title', 'US Potential GDP updates during the Great Recession','showlegend', true,'width', 800,...
'xaxis', struct('domain', [0, 0.9],'title','Year'), ...
'yaxis', struct('title', fred_GDP.Units(:),'anchor', 'free','side', 'left','position',0) );
response = plotly(data, struct('layout', layout, 'filename', 'GreatRecession_PotentialGDP', 'fileopt', 'overwrite'));
response.data=data; response.layout=layout;
% Graph has been created let's save a pdf copy to inside a folder called Graphs (folder must already exist or matlab will error)
saveplotlyfig(response, './Graphs/GreatRecession_PotentialGDP.pdf')

%% Example 6
% Inflation Rates in various countries

CountryCodes2LVec={'DE','FR','IT','GB','US','AU','NZ'};
CountryCodes3LVec={'DEU','FRA','ITA','GBR','USA','AUS','NZL'};
CountryNameVec={'Germany','France','Italy','United Kingdom','USA','Australia','NewZealand'};
ColorStringVec={'#1f77b4','#727272','#f1595f','#79c36a','#599ad3','#f9a65a','#9e66ab','#cd7058','#d77fb3'};

StartDate='1960-01-01'
EndDate='2014-12-31'

data={};
for ii=1:length(CountryCodes2LVec)
    CountryCode2L=CountryCodes2LVec{ii};
    CountryCode3L=CountryCodes3LVec{ii};
    CountryName=CountryNameVec{ii};
    
    if strcmp(CountryCode2L,'AU') || strcmp(CountryCode2L,'NZ')
        % Consumer Price Index of All Items in the United Kingdom (Index 2010=100, Monthly, Not Seasonally Adjusted)
        fred_InflationRate = getFredData([CountryCode3L,'CPIALLQINMEI'], StartDate, EndDate,'pca','a','avg')
    else
        % Consumer Price Index of All Items in the United Kingdom (Index 2010=100, Monthly, Not Seasonally Adjusted)
        fred_InflationRate = getFredData([CountryCode3L,'CPIALLMINMEI'], StartDate, EndDate,'pca','a','avg')
    end
    OECD_InflationRate(:,ii)=fred_InflationRate.Data(:,2);
    
    if ii==1
        annualdates=fred_InflationRate.Data(:,1);
    end
    
    trace1= struct('x', {cellstr(datestr(annualdates,'yyyy'))},'y',OECD_InflationRate(:,ii),'name', CountryName,'type', 'scatter');% ,'line', struct('color', ColorString));
    data = {data{:}, trace1};
end

layout = struct('title', 'Inflation Rates in Various Countries','showlegend', true,'width', 800,'xaxis', struct('domain', [0, 0.9],'title','Year'), ...
    'yaxis', struct('title', 'Percent (Annual Rate)','titlefont', struct('color', 'black'),'tickfont', struct('color', 'black'),...
    'anchor', 'free','side', 'left','position',0) );
response = plotly(data, struct('layout', layout, 'filename', 'SomeOECD_InflationRates', 'fileopt', 'overwrite'));
response.data=data; response.layout=layout;
saveplotlyfig(response, ['./Graphs/SomeOECD_InflationRates.pdf'])

%% Example 7
%% Federal Reserve Balance Sheet in the Great Recession
GRdate1='2004-01-01';
GRdate2='2015-01-01';

% All Federal Reserve Banks – Total Assets, Eliminations from Consolidation (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WALCL = getFredData('WALCL', GRdate1, GRdate2)
trace1= struct('x', {cellstr(datestr(fred_WALCL.Data(:,1),'yyyy-mm'))},'y',fred_WALCL.Data(:,2),'name', 'Fed Reserve: Total Assets','type', 'scatter');% ,'line', struct('color', ColorString));

% Mortgage-backed securities held by the Federal Reserve: All Maturities (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_MBST = getFredData('MBST', GRdate1, GRdate2)
% Federal agency debt securities held by the Federal Reserve: All Maturities (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_FEDDT = getFredData('FEDDT', GRdate1, GRdate2)
% Assets – Unamortized premiums on securities held outright (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WUPSHO = getFredData('WUPSHO', GRdate1, GRdate2)
% Assets – Unamortized discounts on securities held outright (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WUDSHO = getFredData('WUDSHO', GRdate1, GRdate2)
fred_FEDDT_MBST_ETC.Data=[fred_MBST.Data(:,1),fred_FEDDT.Data(:,2)+fred_MBST.Data(:,2)+fred_WUPSHO.Data(:,2)+fred_WUDSHO.Data(:,2)];
trace2= struct('x', {cellstr(datestr(fred_MBST.Data(:,1),'yyyy-mm'))},'y',fred_FEDDT_MBST_ETC.Data(:,2),'name', 'Fed Agency Debt + MBS','type', 'scatter');% ,'line', struct('color', ColorString));
trace2_1= struct('x', {cellstr(datestr(fred_MBST.Data(:,1),'yyyy-mm'))},'y',fred_MBST.Data(:,2),'name', 'Mortgage Backed Securities','type', 'scatter');% ,'line', struct('color', ColorString));
trace2_2= struct('x', {cellstr(datestr(fred_FEDDT.Data(:,1),'yyyy-mm'))},'y',fred_FEDDT.Data(:,2),'name', 'Fed Agency Debt','type', 'scatter');% ,'line', struct('color', ColorString));

% Central Bank Liquidity Swaps held by the Federal Reserve: All Maturities (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_SWPT = getFredData('SWPT', GRdate1, GRdate2)
trace3= struct('x', {cellstr(datestr(fred_SWPT.Data(:,1),'yyyy-mm'))},'y',fred_SWPT.Data(:,2),'name', 'Liquidity to Key Markets (Liq. Swaps)','type', 'scatter');% ,'line', struct('color', ColorString));

% Lending to Banks
% Factors Supplying Reserve Balances – Loans (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WLCFLL = getFredData('WLCFLL', GRdate1, GRdate2)
% Assets – Repurchase Agreements (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WARAL = getFredData('WARAL', GRdate1, GRdate2)
% Factors Supplying Reserve Balances – Net Portfolio Holdings of TALF LLC (DISCONTINUED SERIES) (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WNPHTALFL = getFredData('WNPHTALFL', GRdate1, GRdate2)
TALFcorrection=1
% Maiden Lane LLC are the bailouts to Bear Sterns and AIG.
% Factors Supplying Reserve Balances – Net Portfolio Holdings of Maiden Lane LLC (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WNPHML1L = getFredData('WNPHML1L', GRdate1, GRdate2)
% Factors Supplying Reserve Balances – Net Portfolio Holdings of Maiden Lane II LLC (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WNPHML2L = getFredData('WNPHML2L', GRdate1, GRdate2)
% Factors Supplying Reserve Balances – Net Portfolio Holdings of Maiden Lane III LLC (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WNPHML3L = getFredData('WNPHML3L', GRdate1, GRdate2)
StandardLending=-Inf*ones(size(fred_WLCFLL.Data(:,2)));
for ii=1:size(fred_WLCFLL.Data,1)
    date_c=fred_WLCFLL.Data(ii,1);
    StandardLending(ii)=fred_WLCFLL.Data(ii,2);
    for jj=1:5
        if jj==1
            fredData=fred_WARAL.Data;
        elseif jj==2
            clear fredData
            fredData=[fred_WNPHTALFL.Data(:,1), fred_WNPHTALFL.Data(:,2)*TALFcorrection];
        elseif jj==3
            fredData=fred_WNPHML1L.Data;
        elseif jj==4
            fredData=fred_WNPHML2L.Data;
        elseif jj==5
            fredData=fred_WNPHML3L.Data;
        end
        
        [val,ind]= min(abs(fredData(:,1)-date_c));
        if val==0
            StandardLending(ii)=StandardLending(ii)+fredData(ind,2);
        end
    end
end
trace4=  struct('x', {cellstr(datestr(fred_WLCFLL.Data(:,1),'yyyy-mm'))},'y',StandardLending,'name', 'Lending to Banks','type', 'scatter');% ,'line', struct('color', ColorString));

% Treasury Holdings
% U.S. Treasury securities held by the Federal Reserve: All Maturities (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_TREAST = getFredData('TREAST', GRdate1, GRdate2)
trace5= struct('x', {cellstr(datestr(fred_TREAST.Data(:,1),'yyyy-mm'))},'y',fred_TREAST.Data(:,2),'name', 'Treasuries','type', 'scatter');% ,'line', struct('color', ColorString));
% Breakdown of Treasuries
% U.S. Treasury securities held by the Federal Reserve: Maturing in over 10 years (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_TREAS10Y = getFredData('TREAS10Y', GRdate1, GRdate2)
% U.S. Treasury securities held by the Federal Reserve: Maturing in over 5 years to 10 years (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_TREAS5T10 = getFredData('TREAS5T10', GRdate1, GRdate2)
% U.S. Treasury securities held by the Federal Reserve: Maturing in over 1 year to 5 years (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_TREAS1T5 = getFredData('TREAS1T5', GRdate1, GRdate2)
% U.S. Treasury securities held by the Federal Reserve: Maturing in 91 days to 1 year (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_TREAS911Y = getFredData('TREAS911Y', GRdate1, GRdate2)
% U.S. Treasury securities held by the Federal Reserve: Maturing in 16 days to 90 days (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_TREAS1590 = getFredData('TREAS1590', GRdate1, GRdate2)
% U.S. Treasury securities held by the Federal Reserve: Maturing within 15 days (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_TREAS15 = getFredData('TREAS15', GRdate1, GRdate2)
LongTermTreasuries=fred_TREAS10Y.Data(:,2)+fred_TREAS5T10.Data(:,2);
ShortTermTreasuries=fred_TREAS1590.Data(:,2)+fred_TREAS15.Data(:,2)+fred_TREAS911Y.Data(:,2)+fred_TREAS1T5.Data(:,2);

% Miscellany
% Factors Supplying Reserve Balances – Reserve Bank Credit – Other Federal Reserve Assets (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WOFRAL = getFredData('WOFRAL', GRdate1, GRdate2)
% Factors Supplying Reserve Balances – Float (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WOFSRBFL = getFredData('WOFSRBFL', GRdate1, GRdate2)
% Factors Supplying Reserve Balances – Treasury Currency Outstanding (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WTCOL = getFredData('WTCOL', GRdate1, GRdate2)
% Assets – Special Drawing Rights Certificate Account (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WASDRAL = getFredData('WASDRAL', GRdate1, GRdate2)
% Factors Supplying Reserve Balances – Gold Stock (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WOFSRBGSL = getFredData('WOFSRBGSL', GRdate1, GRdate2)
% Assets – Foreign Currency Denominated Assets (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WFCDA = getFredData('WFCDA', GRdate1, GRdate2)
Misc=fred_WOFRAL.Data(:,2)+fred_WOFSRBFL.Data(:,2)+fred_WTCOL.Data(:,2)+fred_WASDRAL.Data(:,2)+fred_WOFSRBGSL.Data(:,2)+fred_WFCDA.Data(:,2);
trace6= struct('x', {cellstr(datestr(fred_WOFRAL.Data(:,1),'yyyy-mm'))},'y',Misc,'name', 'Misc.','type', 'scatter');% ,'line', struct('color', ColorString));

% Much of the Bank Lending actually counts in the 'Reserve Bank Credit'
% line, but not in the subtotals. (Eg.
% http://research.stlouisfed.org/fred2/release/tables?rid=20&eid=2157&od=2009-02-28#)
% Factors Supplying Reserve Balances – Reserve Bank Credit (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WOFSRBRBC = getFredData('WOFSRBRBC', GRdate1, GRdate2)
%Factors Supplying Reserve Balances – Securities Held Outright (Millions of Dollars, Weekly, As of Wednesday, Not Seasonally Adjusted)
fred_WSHOSHO = getFredData('WSHOSHO', GRdate1, GRdate2)
OtherLending=fred_WOFSRBRBC.Data(:,2)-fred_WSHOSHO.Data(:,2)-fred_WUPSHO.Data(:,2)-fred_WUDSHO.Data(:,2)-fred_WOFSRBFL.Data(:,2)-fred_SWPT.Data(:,2)-StandardLending;
%StandardLending: -fred_WARAL.Data(:,2)-fred_WLCFLL.Data(:,2)-fred_WNPHML1L.Data(:,2)-fred_WNPHML2L.Data(:,2)-fred_WNPHML3L.Data(:,2)-fred_WNPHTALFL.Data(:,2)-fred_WOFRAL.Data(:,2);

trace2a= struct('x', {cellstr(datestr(fred_TREAST.Data(:,1),'yyyy-mm'))},'y',fred_FEDDT_MBST_ETC.Data(:,2)+fred_SWPT.Data(:,2)+OtherLending+StandardLending+fred_TREAST.Data(:,2)+Misc,'name', 'Fed Agency Debt + MBS','type', 'scatter','fill','tonexty');
trace3a= struct('x', {cellstr(datestr(fred_TREAST.Data(:,1),'yyyy-mm'))},'y',fred_SWPT.Data(:,2)+OtherLending+StandardLending+fred_TREAST.Data(:,2)+Misc,'name', 'Liquidity to Key Markets (Currency Swaps)','type', 'scatter','fill','tonexty');
trace4a= struct('x', {cellstr(datestr(fred_TREAST.Data(:,1),'yyyy-mm'))},'y',OtherLending+StandardLending+fred_TREAST.Data(:,2)+Misc,'name', 'Lending to Banks (inc. Bailouts)','type', 'scatter','fill','tonexty');
%trace5a= struct('x', {cellstr(datestr(fred_TREAST.Data(:,1),'yyyy-mm'))},'y',fred_TREAST.Data(:,2)+Misc,'name', 'Treasuries','type', 'scatter','fill','tonexty');
trace5a_1= struct('x', {cellstr(datestr(fred_TREAST.Data(:,1),'yyyy-mm'))},'y',LongTermTreasuries+ShortTermTreasuries+Misc,'name', 'Longer-Term Treasuries','type', 'scatter','fill','tonexty');
trace5a_2= struct('x', {cellstr(datestr(fred_TREAST.Data(:,1),'yyyy-mm'))},'y',ShortTermTreasuries+Misc,'name', 'Short-Term Treasuries','type', 'scatter','fill','tonexty');
trace6a= struct('x', {cellstr(datestr(fred_TREAST.Data(:,1),'yyyy-mm'))},'y',Misc,'name', 'Miscellaneous','type', 'scatter','fill','tozeroy');

data={trace6a,trace5a_2,trace5a_1,trace4a,trace3a,trace2a};
layout = struct('title', 'US Federal Reserve Balance Sheet in Great Recession','showlegend', true,'width', 800,'xaxis', struct('domain', [0, 0.9],'title','Year'), ...
    'yaxis', struct('title', 'Millions of Dollars','titlefont', struct('color', 'black'),'tickfont', struct('color', 'black'),...
    'anchor', 'free','side', 'left','position',0) );
response = plotly(data, struct('layout', layout, 'filename', 'GreatRecession_FedReserveBalanceSheet', 'fileopt', 'overwrite'));
response.data=data; response.layout=layout;
saveplotlyfig(response, ['./Graphs/GreatRecession_FedReserveBalanceSheet.pdf'])

%% Example 8
% Employed Population: Aged 15 and Over: All Persons for New Zealand (Persons, Quarterly, Seasonally Adjusted)
fred_EmpPop = getFredData('LFEMTTTTNZQ647S', StartDate, EndDate)
% Unemployed Population: Aged 15 and Over: All Persons for New Zealand (Persons, Quarterly, Seasonally Adjusted)
fred_UnempPop = getFredData('LFUNTTTTNZQ647S', StartDate, EndDate)
% Working Age Population: Aged 15 and Over: All Persons for New Zealand (Persons, Quarterly, Seasonally Adjusted)
fred_WorkingAgePop = getFredData('LFWATTTTNZQ647S', StartDate, EndDate)
% Unemployment Rate: Aged 15 and Over: All Persons for New Zealand (Percent, Quarterly, Seasonally Adjusted)
fred_Unemp = getFredData('LRUNTTTTNZQ156S', StartDate, EndDate)

trace1= struct('x', {cellstr(datestr(fred_EmpPop.Data(:,1),'yyyy-QQ'))},'y',fred_EmpPop.Data(:,2),'name', 'Employed Population','type', 'scatter','fill','tozeroy','line', struct('color', 'hsv(210,80,100)'));
trace2= struct('x', {cellstr(datestr(fred_UnempPop.Data(:,1),'yyyy-QQ'))},'y',fred_EmpPop.Data(:,2)+fred_UnempPop.Data(:,2),'name', 'Unemployed Population','type', 'scatter','fill','tonexty','line', struct('color', 'hsv(30,80,100)'));
trace3= struct('x', {cellstr(datestr(fred_WorkingAgePop.Data(:,1),'yyyy-QQ'))},'y',fred_WorkingAgePop.Data(:,2),'name', 'Working Age Population','type', 'scatter','line', struct('color', 'hsv(90,100,80)'));
trace4= struct('x', {cellstr(datestr(fred_Unemp.Data(:,1),'yyyy-QQ'))},'y',fred_Unemp.Data(:,2),'name', 'Unemployment Rate','type', 'scatter','yaxis','y2','line', struct('color', 'hsv(0,80,100)'));
data = {trace1,trace2,trace3,trace4};
layout = struct('title', 'Labour Force Population in New Zealand (Ages 15+)','showlegend', true,'width', 800,...
    'xaxis', struct('title','Year','showgrid',false,'anchor','y2','tickangle',-45,'nticks',20),...
    'yaxis', struct('title', 'Persons','titlefont', struct('color', 'black'),'tickfont', struct('color', 'black'),'position',0, 'domain', [0.25, 1],'anchor', 'free','showgrid',false),...
    'yaxis2', struct('title','Percent','titlefont', struct('color', 'black'),'tickfont', struct('color', 'black'),'position',0, 'domain', [0, 0.25],'anchor', 'free','showgrid',false),...
    'legend', struct('traceorder','reversed') );
response = plotly(data, struct('layout', layout, 'filename', 'NZ_LabourForce', 'fileopt', 'overwrite'));
response.data=data; response.layout=layout;
saveplotlyfig(response, './Graphs/NZ_LabourForce.pdf')

%% Example 9
% First: Import the GDP and NBER Recession dating data
% Gross Domestic Product by Expenditure in Constant Prices: Total Gross Domestic Product for the United States (quarterly, seasonally adjusted)
fred_GDP = getFredData('NAEXKP01USQ652S', '1970-01-01', '2015-06-30')
% NBER based Recession Indicators for the United States from the Period following the Peak through the Trough (+1 or 0, Quarterly, Not Seasonally Adjusted)
fred_USRECQ = getFredData('USRECQ', '1970-01-01', '2015-06-30')
% Create the regression shading. I do this separately to the rest of the graph just to as to make it easier to add to your own graphs
traceUSRECQ= struct('x', {cellstr(datestr(fred_USRECQ.Data(:,1),'yyyy-QQ'))},'y',fred_USRECQ.Data(:,2),'name','(Recession)','type', 'scatter','fill','tozeroy','showlegend',false,'line', struct('color','rgb(200,200,200)','width',0,'opacity',0.2,'shape','hvh'),'yaxis','y2','marker', struct('size', 0));
axisUSRECQ=struct('title', ' ','showticklabel',false,'autotick',false,'tickfont',struct('color', 'white'),'linewidth',0,'showgrid',false,'zeroline',false,'side', 'left');
% Graph of US RGDP
trace1= struct('x', {cellstr(datestr(fred_GDP.Data(:,1),'yyyy-QQ'))},'y',fred_GDP.Data(:,2),'name','US GDP','type', 'scatter');
data = {trace1,traceUSRECQ};
layout = struct('title','US Real GDP','showlegend',true,'width',800,...
    'xaxis', struct('domain', [0, 1],'title','Year','showgrid',false), ...
    'yaxis', struct('title', 'GDP','titlefont', struct('color', 'black'),'tickfont', struct('color', 'black'),'side', 'left','position',0,'overlaying', 'y2'),...
    'yaxis2', axisUSRECQ,...
    'legend', struct('x',0,'y',1));
response = plotly(data, struct('layout', layout, 'filename','US_RGDP', 'fileopt', 'overwrite'));
% Graph has been created with name US_RGDP, but let's save a pdf copy to inside a folder called Graphs (folder must already exist or matlab will error)
response.data=data; response.layout=layout;
saveplotlyfig(response, './Graphs/US_RGDP.pdf')
% Note: Graph in link does not include the graph title, and uses a different time period, and forces the line color to be blue, but otherwise the same.


