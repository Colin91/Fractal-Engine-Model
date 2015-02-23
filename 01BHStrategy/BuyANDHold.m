clear
clc
clf
%AUDUSD.xlsx
data  = xlsread('EURUSD.xlsx')
j = 15000;
Price = data(1:j,1);


A_PERFORMANCE_TRADES = zeros(length(Price),1); %% 1
A_PERFORMANCE_TRADES_RET = zeros(length(Price),3); %% 2 %% To remove recurring 0's
CIPrice = zeros(length(Price),35); %% 3 
ListOfTrades = zeros(length(Price),3); %% 4 
LOSS_TRADES = 0; %% 5
PROFIT_TRADES = 0; %% 6
SHARPE = zeros(length(Price),1); %% 7
Sum = 0; %% 8

SHARPE_MEAN = 0;
SHARPE_SDEV = 0;
SHARPE_INDEX = 0;

CURRENCY_ADJUST = 0;

LongEntry = 0;
LongExit = 0;
ShortEntry = 0;
ShortExit = 0;

BUY_LOT_SIZE = 100000;
%SELL_LOT_SIZE = 100000;

LongDifference = 0;
ShortDifference = 0;

TOTAL_COUNTER = 0;

mode = 0;
ARTIFICIAL_INDEX = 0;
ARTIFICIAL_INDEX1 = 0;
ARTIFICIAL_INDEX2 = 0;

CUMU_RETURNS = 0;
Account = 100000;
RISK_FREE_RATE = 0;

BUY_Counter = 0;
SELL_Counter = 0;

LOT = zeros(length(Price),2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TProfit = 0;


for i = 300: length(Price)

    SMA(i) = sum(Price(i-299:i))/300;
    
    CIPrice(i-299,1) = Price(i);
    CIPrice(i-299,7) = Price(i);
    
    CURRENCY_ADJUST = 1/Price(i);
            
       
            
        CIPrice(i-299,4) = Price(i);
        LongEntry = Price(i-1);
        TOTAL_COUNTER = 1;

       
            
        CIPrice(i-299,5) = Price(i);
        LongExit = Price(i);

        ARTIFICIAL_INDEX2 = ARTIFICIAL_INDEX2 + 1;

        LongDifference = ((LongExit - LongEntry)*BUY_LOT_SIZE)*CURRENCY_ADJUST;

        LOT(ARTIFICIAL_INDEX2,1) = (((LongExit - LongEntry)*BUY_LOT_SIZE)*CURRENCY_ADJUST);

        CIPrice(i-299,6) = ((LongExit - LongEntry)*BUY_LOT_SIZE)*CURRENCY_ADJUST;

        %BUY_LOT_SIZE = BUY_LOT_SIZE + 10000;

        if LongDifference > 0
            PROFIT_TRADES = PROFIT_TRADES + 1;
        elseif LongDifference < 0
            LOSS_TRADES = LOSS_TRADES + 1;
        end

        ARTIFICIAL_INDEX = ARTIFICIAL_INDEX + 1;
        %ARTIFICIAL_INDEX2 = ARTIFICIAL_INDEX2 +1;

        Account = Account + LongDifference; 

        CUMU_RETURNS = CUMU_RETURNS + LongDifference;

        A_PERFORMANCE_TRADES(ARTIFICIAL_INDEX,1) = CUMU_RETURNS;

        %Account = Account + LongDifference;


        ARTIFICIAL_INDEX1 = ARTIFICIAL_INDEX1 + 1;
        ListOfTrades(ARTIFICIAL_INDEX1,1) = ((LongExit - LongEntry)*BUY_LOT_SIZE)*CURRENCY_ADJUST;

        ListOfTrades(ARTIFICIAL_INDEX1,2) = CUMU_RETURNS;
        ListOfTrades(ARTIFICIAL_INDEX1,3) = Account + CUMU_RETURNS;
        A_PERFORMANCE_TRADES_RET(ARTIFICIAL_INDEX2,1) = ((LongDifference/Account)*100) - RISK_FREE_RATE;


        if i==j
            
            TProfit = ((Price(j) - Price(1))*BUY_LOT_SIZE)*CURRENCY_ADJUST;
            
        end    
            
            
            
            

        
end   
        
    %{
ZA_PERFORMANCE_TRADES = zeros(length(Price),1); %% 1
ZA_PERFORMANCE_TRADES_RET = zeros(length(Price),3); %% 2 %% To remove recurring 0's
ZCIPrice = zeros(length(Price),35); %% 3 
ZListOfTrades = zeros(length(Price),3); %% 4 
ZLOSS_TRADES = 0; %% 5
ZPROFIT_TRADES = 0; %% 6
ZSHARPE = zeros(length(Price),1); %% 7
ZSum = 0; %% 8

ZSHARPE_MEAN = 0;
ZSHARPE_SDEV = 0;
ZSHARPE_INDEX = 0;

SELL_LOT_SIZE = 100000;

LongDifference = 0;
ShortDifference = 0;

ZTOTAL_COUNTER = 0;

mode = 0;
ZARTIFICIAL_INDEX = 0;
ZARTIFICIAL_INDEX1 = 0;
ZARTIFICIAL_INDEX2 = 0;

ZCUMU_RETURNS = 0;
ZAccount = 100000;
ZRISK_FREE_RATE = 0;

SELL_Counter = 0;

ZLOT = zeros(length(Price),2);
SELL_TOTAL_COUNTER = 0
    
    if (Price(i) < SMA(i) && Price(i) < SMA(i-1) && Price(i) < SMA(i-2) && Price(i) < SMA(i-3) && Price(i) < SMA(i-4) && (Price(i-1) > SMA(i-1) || Price(i-1) == SMA(i-1))) && SELL_TOTAL_COUNTER == 0 %ShortEntry
    
        ZCIPrice(i-299,4) = Price(i);
        ShortEntry = Price(i);
        ZTOTAL_COUNTER = 1;
        SELL_TOTAL_COUNTER = 1;
        
        
    elseif (Price(i) > SMA(i) && Price(i) > SMA(i-1) && Price(i) > SMA(i-50)) && (((Price(i-1) < SMA(i-1) || Price(i-1) == SMA(i-1)))) %ShortExit
        
        ZCIPrice(i-299,5) = Price(i);
        ShortExit = Price(i);

        ShortDifference = ((ShortEntry - ShortExit)*SELL_LOT_SIZE)*CURRENCY_ADJUST;
        ZCIPrice(i-299,6) = ((ShortEntry - ShortExit)*SELL_LOT_SIZE)*CURRENCY_ADJUST;
        
        SELL_LOT_SIZE = SELL_LOT_SIZE + 10000;

        if ShortDifference > 0
            ZPROFIT_TRADES = ZPROFIT_TRADES + 1;
        elseif ShortDifference < 0
            ZLOSS_TRADES = ZLOSS_TRADES + 1;
        end

        ZCUMU_RETURNS = ZCUMU_RETURNS + ShortDifference;

        ZARTIFICIAL_INDEX1 = ZARTIFICIAL_INDEX1 + 1;
        ZARTIFICIAL_INDEX2 = ZARTIFICIAL_INDEX2 + 1;

        ZA_PERFORMANCE_TRADES(ZARTIFICIAL_INDEX1,2) = ShortDifference;
        
        ZAccount = ZAccount + ShortDifference;
        %Account = Account + ShortDifference;



        ZListOfTrades(ZARTIFICIAL_INDEX1,1) = ((ShortEntry - ShortExit)*SELL_LOT_SIZE)*CURRENCY_ADJUST;
        ZListOfTrades(ZARTIFICIAL_INDEX1,2) = ZCUMU_RETURNS;
        ZListOfTrades(ZARTIFICIAL_INDEX1,3) = ZAccount + ZCUMU_RETURNS;
        ZA_PERFORMANCE_TRADES_RET(ZARTIFICIAL_INDEX2,1) = ((ShortDifference/(ZAccount))*100) - RISK_FREE_RATE;
              
   
        
    elseif i==j
        
    end
    
    %}
    
    
    
    
    
                 
                  
TOTAL_COUNTER = 0;
SELL_TOTAL_COUNTER = 0;
Sum = sum(ListOfTrades);

Sharpe(1:ARTIFICIAL_INDEX1,1) = A_PERFORMANCE_TRADES_RET(1:ARTIFICIAL_INDEX1,1);
SHARPE_AVERAGE = mean(A_PERFORMANCE_TRADES_RET(1:ARTIFICIAL_INDEX1,1));
SHARPE_STDEV = std(A_PERFORMANCE_TRADES_RET(1:ARTIFICIAL_INDEX1,1));
SHARPE = SHARPE_AVERAGE/SHARPE_STDEV;

%A_Sharpe = sharpe(A_PERFORMANCE_TRADES(1:ARTIFICIAL_INDEX1,1),0);



plot(Price(1:end),'--s');

grid on           

