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

LOT_SIZE = 100000;

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

for i = 30: length(Price)

    SMA(i) = sum(Price(i-29:i))/30;
    
    CIPrice(i-29,1) = Price(i);
    CIPrice(i-29,7) = Price(i);
    
    CURRENCY_ADJUST = 1/Price(i);
    
    if mode == 0
        
        SELL_Counter = 0;
        if ((Price(i) > SMA(i) && Price(i) > SMA(i-1) && Price(i) > SMA(i-2) && Price(i) > SMA(i-3) && Price(i) > SMA(i-4))&&((Price(i-1) < SMA(i-1)) || Price(i-1) == SMA(i-1))) && BUY_Counter == 0 && mode == 0%LongEntry
            
            CIPrice(i-29,4) = Price(i);
            LongEntry = Price(i);
            BUY_Counter = 1;    

        elseif (Price(i) < SMA(i) && Price(i) < SMA(i-1) && Price(i) < SMA(i-2)) && ((Price(i-1) > SMA(i-1) || Price(i-1) == SMA(i-1))) && BUY_Counter == 1 %LongExit    
            
            CIPrice(i-29,5) = Price(i);
            LongExit = Price(i);
            
            
            LongDifference = ((LongExit - LongEntry)*LOT_SIZE)*CURRENCY_ADJUST;
            CIPrice(i-29,6) = ((LongExit - LongEntry)*LOT_SIZE)*CURRENCY_ADJUST;
            
            if LongDifference > 0
                PROFIT_TRADES = PROFIT_TRADES + 1;
            elseif LongDifference < 0
                LOSS_TRADES = LOSS_TRADES + 1;
            end
            
            ARTIFICIAL_INDEX = ARTIFICIAL_INDEX + 1;
            ARTIFICIAL_INDEX2 = ARTIFICIAL_INDEX2 +1;
            
            CUMU_RETURNS = CUMU_RETURNS + LongDifference;
            
            A_PERFORMANCE_TRADES(ARTIFICIAL_INDEX,1) = CUMU_RETURNS;
            
            Account = Account + LongDifference;
            
            
            ARTIFICIAL_INDEX1 = ARTIFICIAL_INDEX1 + 1;
            ListOfTrades(ARTIFICIAL_INDEX1,1) = ((LongExit - LongEntry)*LOT_SIZE)*CURRENCY_ADJUST;
            
            ListOfTrades(ARTIFICIAL_INDEX1,2) = CUMU_RETURNS;
            ListOfTrades(ARTIFICIAL_INDEX1,3) = Account + CUMU_RETURNS;
            A_PERFORMANCE_TRADES_RET(ARTIFICIAL_INDEX2,1) = ((LongDifference/Account)*100) - RISK_FREE_RATE;
            mode = 1;
        
        
        end
        
        
    elseif mode == 1
        
        BUY_Counter = 0;
        
        if (Price(i) < SMA(i) && Price(i) < SMA(i-1) && Price(i) < SMA(i-2) && Price(i) < SMA(i-3) && Price(i) < SMA(i-4) && (Price(i-1) > SMA(i-1) || Price(i-1) == SMA(i-1))) && SELL_Counter == 0 && mode == 1 %ShortEntry

            CIPrice(i-29,10) = Price(i);
            ShortEntry = Price(i);
            SELL_Counter = 1;

        elseif (Price(i) > SMA(i) && Price(i) > SMA(i-1) && Price(i) > SMA(i-2)) && (((Price(i-1) < SMA(i-1) || Price(i-1) == SMA(i-1)))) && SELL_Counter == 1 %ShortExit
            
            CIPrice(i-29,11) = Price(i);
            ShortExit = Price(i);
            
            ShortDifference = ((ShortEntry - ShortExit)*LOT_SIZE)*CURRENCY_ADJUST;
            CIPrice(i-29,12) = ((ShortEntry - ShortExit)*LOT_SIZE)*CURRENCY_ADJUST;
                
            if ShortDifference > 0
                PROFIT_TRADES = PROFIT_TRADES + 1;
            elseif ShortDifference < 0
                LOSS_TRADES = LOSS_TRADES + 1;
            end
            
            CUMU_RETURNS = CUMU_RETURNS + ShortDifference;
            
            ARTIFICIAL_INDEX1 = ARTIFICIAL_INDEX1 + 1;
            ARTIFICIAL_INDEX2 = ARTIFICIAL_INDEX2 + 1;
            
            A_PERFORMANCE_TRADES(ARTIFICIAL_INDEX1,2) = ShortDifference;
            
            Account = Account + ShortDifference;
            
           
            
            ListOfTrades(ARTIFICIAL_INDEX1,1) = ((ShortEntry - ShortExit)*LOT_SIZE)*CURRENCY_ADJUST;
            ListOfTrades(ARTIFICIAL_INDEX1,2) = CUMU_RETURNS;
            ListOfTrades(ARTIFICIAL_INDEX1,3) = Account + CUMU_RETURNS;
            A_PERFORMANCE_TRADES_RET(ARTIFICIAL_INDEX2,1) = ((ShortDifference/(Account))*100) - RISK_FREE_RATE;
            mode = 0;
        
        end
        
    end
    
    
    
end    

Sum = sum(ListOfTrades);

Sharpe(1:ARTIFICIAL_INDEX2,1) = A_PERFORMANCE_TRADES_RET(1:ARTIFICIAL_INDEX2,1);
SHARPE_AVERAGE = mean(A_PERFORMANCE_TRADES_RET(1:ARTIFICIAL_INDEX2,1));
SHARPE_STDEV = std(A_PERFORMANCE_TRADES_RET(1:ARTIFICIAL_INDEX2,1));
SHARPE = SHARPE_AVERAGE/SHARPE_STDEV;

A_Sharpe = sharpe(A_PERFORMANCE_TRADES(1:ARTIFICIAL_INDEX2,1),0);



plot(Price(1:end),'--s');

grid on           
