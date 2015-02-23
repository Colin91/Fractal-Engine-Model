clear
clc
clf

%data = xlsread('EURJPY5Mins.xml')
data = xlsread('EURUSD.xlsx')
%data2 = xlsread('Fibonacci.xls')
p = 1;
j = 15000;
Price = data(p:j,1);

mode = 0;
current = 0;
lagged = 0;
lambda = 0.0382;

LongDCOvershoot = 0;
ShortDCOvershoot = 0;

LONG_CUMU_CHANGE = 0;
SHORT_CUMU_CHANGE = 0;

FRACTAL_INDEX = 0;
FRACTAL_AVERAGE = 0;
FRACTALS = zeros(length(Price),1);
FRACTAL_CUMULATIVE = 0;
FRACTAL_AVERAGE02 = 0;

Account = 100000;
LOT_SIZE = 100000;
TradeMode = 0;
LongEntry = 0;
LongExit = 0;
ShortEntry = 0;
ShortExit = 0;
LongDifference = 0;
ShortDifference = 0;
ListOfTrades = zeros(length(Price),3);

A_PERFORMANCE_TRADES = zeros(length(Price),1); 
A_PERFORMANCE_TRADES_RET = zeros(length(Price),3); %% To remove recurring 0's
SHARPE = zeros(length(Price),1);
SHARPE_MEAN = 0;
SHARPE_SDEV = 0;

SHARPE_INDEX = 0;
PROFIT_TRADES = 0;
LOSS_TRADES = 0;

ENTRY_LONG_PRICE = 0;
ENTRY_SHORT_PRICE = 0;

INITIAL_LONG = 0;
INITIAL_SHORT = 0;

UP_LIMIT_PRICE = 0;
DOWN_LIMIT_PRICE = 0;

DIRECTIONAL_CHANGE_UPMOVE = 0;
DIRECTIONAL_CHANGE_DOWNMOVE = 0;
DEFAULT_FRACTAL = 1.5;
SET_FRACTAL = 0;

Sum = 0;

tickcounter = 0;
tickcounter1 = 0;
copy = 0;
counter = 0;
TempCounter = 0;
TempCounter1 = 0;
TotalTickCounter = 0;

UPCounterDC = 0;
DOWNCounterDC = 0;
DCcounter = 0;

UPCounterDC1 = 0;
DOWNCounterDC1 = 0;
DCcounter1 = 0;

TotalMoveCounter = 0;
TotalMoveCounter1 = 0;

changeInPrice1 = 0;
changeInPrice2 = 0;

DirectionalChange = 0;
DCsize = 0;

DirectionalChange1 = 0;
DCsize1 = 0;
absPriceChange = 0;
Time = 300;
CumuTime = 0;


CIPrice = zeros(length(Price),35);
Change = zeros(length(Price),4);
ArtificialIndex = 1;
ArtificialIndex1 = 1;
PeriodCounter = 100;
alpha = 0;

%%For Scaling Law R/S vs Average Overshoot Tick Count
AverageCounter = 0; %% Equals to DirectionalChange Counter.
RescaledSumOf = 0;
StandardDev = 0; %% For Rescaled Range
CumulativeAverage = 0;
ABSPriceChange = 0;

SL_LONGCOUNTER = 0;
SL_LONGPRICE = 0;

SL_SHORTCOUNTER = 0;
SL_SHORTPRICE = 0;

LIMIT_LONGCOUNTER = 0;
LIMIT_LONGPRICE = 0;

A_PTRADES = 0;
A_LTRADES = 0;

CUMU_RETURNS = 0;
RISK_FREE_RATE = 0;

Sharpe = zeros(length(Price),1);
SHARPE_AVERAGE = 0;
SHARPE_STDEV = 0;
SHARPE = 0;
LIST_OF_FRACTALS = zeros(length(Price),3);

CURRENCY_ADJUST = 0;

%%%%%%%%%%%%%%%NOTE REARRAGED ACCOUNT<<< SHARPE VALUE

for i = 10 : length(Price)
    
    s = Price(i);
    l = Price(i-1); 
    changeInPrice1 = ((l-s)/l)*100; %Downward
    CIPrice(i-9,1) = Price(i);%changeInPrice1;
    
    changeInPrice2 = ((s-l)/s)*100; %Upward
    CIPrice(i-9,7) = Price(i);%changeInPrice2;
      
    CURRENCY_ADJUST = 1/s; %0.77 for JPY and 1 for EURO
    
    if mode == 0   
        
        if s < l %% For Long Trades
            
            tickcounter1 = 0;
            l = s;
            
            LongDifference = ((s - LongEntry)*LOT_SIZE)*CURRENCY_ADJUST;
            
            
            if (((LongDifference >= UP_LIMIT_PRICE)) || ((LongDifference < -2000)))  && TradeMode == 1
                
                SL_LONGCOUNTER = 1;
                SL_LONGPRICE = Price(i);
               
                
                if TradeMode == 1

                    %Contrarion Strat, when an upward DC is activated, you
                    %short and vice versa
                    %Here one should short, but instead I go Long.
                    
                    if SL_LONGCOUNTER == 1
                        
                        LongExit = SL_LONGPRICE;
                        LongDifference = ((LongExit - LongEntry)*LOT_SIZE)*CURRENCY_ADJUST; 
                        CIPrice(i-9,11) = Price(i);
                        CIPrice(i-9,12) = ((LongExit - LongEntry)*LOT_SIZE)*CURRENCY_ADJUST;
                        %Account = Account + LongDifference;
                        %ListOfTrades(ArtificialIndex1,3) = Account+ LongDifference;
                        
                        
                    end                        
                         
                        
                        
                    %CIPrice(i-9,12) = (Price(i) - TotalMoveCounter1)*LOT_SIZE;%((Price(i) - TotalMoveCounter1)./ TotalMoveCounter1)*100; %%UPWARD OS move Different
                    CIPrice(i-9,27) = CIPrice(i-9,12);
                    absPriceChange = absPriceChange + abs((Price(i) - TotalMoveCounter1)./ TotalMoveCounter1);
                    ABSPriceChange = absPriceChange/(absPriceChange-abs((Price(i) - TotalMoveCounter1)./ TotalMoveCounter1));
                    CIPrice(i-9,15) = absPriceChange;
                    ArtificialIndex = ArtificialIndex + 1;
                    Change(ArtificialIndex,1) = abs((Price(i) - TotalMoveCounter1)./ TotalMoveCounter1);
                    %ShortEntry = Price(i);
                                                          
                    
                   

                        if LongEntry ~= 0 && LongExit ~= 0

                        %Account = Account+ShortDifference;

                            ArtificialIndex1 = ArtificialIndex1 + 1;
                            ListOfTrades(ArtificialIndex1,1) = LongDifference;
                            A_PERFORMANCE_TRADES(ArtificialIndex1,1) = LongDifference;
                            
                            
                            
                            
                            CUMU_RETURNS = CUMU_RETURNS + LongDifference;
                            A_PERFORMANCE_TRADES(ArtificialIndex1,2)=CUMU_RETURNS;
                            ListOfTrades(ArtificialIndex1,2) = CUMU_RETURNS;
                            
                            Account = Account + LongDifference;
                            ListOfTrades(ArtificialIndex1,3) = Account;
                            
                            
                            A_PERFORMANCE_TRADES_RET(ArtificialIndex1,1) = ((LongDifference/Account)*100) - RISK_FREE_RATE;
                            
                            if LongDifference > 0
                                
                                PROFIT_TRADES = PROFIT_TRADES + 1;
                                
                            elseif LongDifference < 0
                                
                                LOSS_TRADES = LOSS_TRADES + 1;
                                
                            end

                        elseif LongEntry == 0 && LongExit == 0

                            ListOfTrades(ArtificialIndex1,1) = 0;
                            
                            
                            %{
                            CUMU_RETURNS = CUMU_RETURNS + LongDifference;
                            A_PERFORMANCE_TRADES(ArtificialIndex1,2)=CUMU_RETURNS;
                            ListOfTrades(ArtificialIndex1,2) = CUMU_RETURNS;
                            
                            ListOfTrades(ArtificialIndex1,3) = Account + CUMU_RETURNS;
                            
                            A_PERFORMANCE_TRADES_RET(ArtificialIndex1,1) = ((CUMU_RETURNS/Account)*100)- RISK_FREE_RATE;
                            
                            
                            if A_PERFORMANCE_TRADES(ArtificialIndex1,1) == 0
                                
                                A_PERFORMANCE_TRADES(ArtificialIndex1,1) = null;
                                
                            end
                            
                            
                            if LongDifference > 0
                                
                                PROFIT_TRADES = PROFIT_TRADES + 1;
                                
                            elseif LongDifference < 0
                                
                                LOSS_TRADES = LOSS_TRADES + 1;
                                
                            end
                            %}
                        end

                    
                    counter = i;
                    TempCounter = counter;

                    %%%%%
                    TotalTickCounter1 = (i - TempCounter1);
                    CIPrice(i-9,14) = TotalTickCounter1;

                    CumuTime = CumuTime + (TotalTickCounter1);%*Time)
                    CIPrice(i-9,16) = CumuTime;

                        if CIPrice(i-9,16) ~= 0

                             CIPrice(i-9,17) = TotalTickCounter1; %%Length Of Overshoot In tick count
                             AverageCounter = AverageCounter + 1;
                             CIPrice(i-9,18) = (CumuTime/AverageCounter); 
                             RescaledSumOf = abs(TotalTickCounter1-(CumuTime/AverageCounter));
                             CIPrice(i-9,19) = RescaledSumOf; %%For Rescaled Range
                             StandardDev = ((TotalTickCounter1-(CumuTime/AverageCounter))^2);
                             CIPrice(i-9,20) =  sqrt(StandardDev/AverageCounter);
                             CIPrice(i-9,21) =  RescaledSumOf/(sqrt(StandardDev/AverageCounter));
                             CumulativeAverage = CumulativeAverage + (CumuTime/AverageCounter);
                             CIPrice(i-9,22) = CumulativeAverage;%%Cumulative OS Average from 18
                             CIPrice(i-9,23) = log(RescaledSumOf/(sqrt(StandardDev/AverageCounter)));
                             CIPrice(i-9,24) = log(CumulativeAverage);
                             CIPrice(i-9,25) = log(RescaledSumOf/(sqrt(StandardDev/AverageCounter)))/log(CumulativeAverage/2);   
                             CIPrice(i-9,26) = ABSPriceChange;


                        end



                    TotalTickCounter1 = 0;

                    DOWNCounterDC =  DOWNCounterDC + 1;
                    DCsize = DCsize + (((Price(i-1)- TotalMoveCounter1)./ Price(i-1))*100);
                    l = s;
                    tickcounter = 1;
                    DirectionalChange = DirectionalChange + 1;
                    
                     
                    %DOWN_LIMIT_PRICE = 0;]
                    
                    TradeMode = 0;

                 end  
                
            end
            
            
            
        elseif changeInPrice2 >= lambda%% This will END the Long trade, marking a directional change in the opp direction.
            
            CIPrice(i-9,2) = abs(changeInPrice1); %Part of Overshoot changeInPrice1 - lambda
            %CIPrice(i-9,3) = (abs(changeInPrice1) - lambda);
            
            ShortEntry = Price(i); %%%%%%%%%%%%%%%%%%%%%%%
                        
            CIPrice(i-9,4) = Price(i);
            
            TotalMoveCounter = Price(i); %%%%%%%
            
            CIPrice(i-9,32) = ((Price(i) - Price(i-1))*LOT_SIZE)*CURRENCY_ADJUST; %abs((Price(i) - Price(i-1))./ Price(i-1));
            
            if SET_FRACTAL == 0
                        
                ShortDCOvershoot = 0;%(changeInPrice2 - lambda)*DEFAULT_FRACTAL;
                DOWN_LIMIT_PRICE = (((abs(changeInPrice1/100))*DEFAULT_FRACTAL)*LOT_SIZE)*CURRENCY_ADJUST;
                CIPrice(i-9,3) = (((abs(changeInPrice1/100))*DEFAULT_FRACTAL)*LOT_SIZE)*CURRENCY_ADJUST;
                
            elseif SET_FRACTAL ~= 0
                
                ShortDCOvershoot = 0;%(changeInPrice2 - lambda)*SETFRACTAL;
                DOWN_LIMIT_PRICE = (((abs(changeInPrice1/100))*SETFRACTAL)*LOT_SIZE)*CURRENCY_ADJUST;
                CIPrice(i-9,3) = (((abs(changeInPrice1/100))*SETFRACTAL)*LOT_SIZE)*CURRENCY_ADJUST;
                
            end
            
            
            
             if TotalMoveCounter1 ~= 0%%Set initial value to lambda
                
                
                
                
                if TradeMode == 1

                    %Contrarion Strat, when an upward DC is activated, you
                    %short and vice versa
                    %Here one should short, but instead I go Long.
                    %CIPrice(i-9,11) = Price(i);
                    %CIPrice(i-9,12) = (Price(i) - TotalMoveCounter1)*LOT_SIZE;%((Price(i) - TotalMoveCounter1)./ TotalMoveCounter1)*100; %%UPWARD OS move Different
             
                        
                    LongExit = Price(i);
                    LongDifference = ((LongExit - LongEntry)*LOT_SIZE)*CURRENCY_ADJUST;
                    CIPrice(i-9,11) = Price(i);
                    CIPrice(i-9,12) = ((LongExit - LongEntry)*LOT_SIZE)*CURRENCY_ADJUST;
                    
                    %Account = Account + LongDifference;
                    %ListOfTrades(ArtificialIndex1,3) = Account + LongDifference;
                    

            
                    SL_LONGCOUNTER = 0;     
                    
                    %CIPrice(i-9,12) = (Price(i) - TotalMoveCounter1)*LOT_SIZE;%((Price(i) - TotalMoveCounter1)./ TotalMoveCounter1)*100; %%UPWARD OS move Different
                    CIPrice(i-9,27) = CIPrice(i-9,12);
                    absPriceChange = absPriceChange + abs((Price(i) - TotalMoveCounter1)./ TotalMoveCounter1);
                    ABSPriceChange = absPriceChange/(absPriceChange-abs((Price(i) - TotalMoveCounter1)./ TotalMoveCounter1));
                    CIPrice(i-9,15) = absPriceChange;
                    ArtificialIndex = ArtificialIndex + 1;
                    Change(ArtificialIndex,1) = abs((Price(i) - TotalMoveCounter1)./ TotalMoveCounter1);

                        if LongEntry ~= 0 && LongExit ~= 0

                        %Account = Account+ShortDifference;

                            ArtificialIndex1 = ArtificialIndex1 + 1;
                            ListOfTrades(ArtificialIndex1,1) = LongDifference;
                            
                            A_PERFORMANCE_TRADES(ArtificialIndex1,1) = LongDifference;
                            
                            
                            CUMU_RETURNS = CUMU_RETURNS + LongDifference;
                            
                            A_PERFORMANCE_TRADES(ArtificialIndex1,2)=CUMU_RETURNS;
                            
                            ListOfTrades(ArtificialIndex1,2) = CUMU_RETURNS;
                            
                            Account = Account + LongDifference; 
                            
                            ListOfTrades(ArtificialIndex1,3) = Account;
                            
                            A_PERFORMANCE_TRADES_RET(ArtificialIndex1,1) = ((LongDifference/Account)*100) - RISK_FREE_RATE;
                            
                            
                            if LongDifference > 0
                                
                                PROFIT_TRADES = PROFIT_TRADES + 1;
                                
                            elseif LongDifference < 0
                                
                                LOSS_TRADES = LOSS_TRADES + 1;
                                
                            end

                        elseif LongEntry == 0 && LongExit == 0

                            ListOfTrades(ArtificialIndex1,1) = 0;
                            %{
                            CUMU_RETURNS = CUMU_RETURNS + LongDifference;
                            
                            ListOfTrades(ArtificialIndex1,3) = Account + CUMU_RETURNS;
                            
                            A_PERFORMANCE_TRADES(ArtificialIndex1,2)=CUMU_RETURNS;
                            A_PERFORMANCE_TRADES_RET(ArtificialIndex1,1) = ((CUMU_RETURNS/Account)*100) - RISK_FREE_RATE;
                            ListOfTrades(ArtificialIndex1,2) = CUMU_RETURNS;
                            
                            if A_PERFORMANCE_TRADES(ArtificialIndex1,1) == 0
                                
                                A_PERFORMANCE_TRADES(ArtificialIndex1,1) = null;
                                
                            end
                            
                            
                            if LongDifference > 0
                                
                                PROFIT_TRADES = PROFIT_TRADES + 1;
                                
                            elseif LongDifference < 0
                                
                                LOSS_TRADES = LOSS_TRADES + 1;
                                
                            end
                            %}
                        end

                    counter = i;
                    TempCounter = counter;

                    %%%%%
                    TotalTickCounter1 = (i - TempCounter1);
                    CIPrice(i-9,14) = TotalTickCounter1;

                    CumuTime = CumuTime + (TotalTickCounter1);%*Time)
                    CIPrice(i-9,16) = CumuTime;

                        if CIPrice(i-9,16) ~= 0

                             CIPrice(i-9,17) = TotalTickCounter1; %%Length Of Overshoot In tick count
                             AverageCounter = AverageCounter + 1;
                             CIPrice(i-9,18) = (CumuTime/AverageCounter); 
                             RescaledSumOf = abs(TotalTickCounter1-(CumuTime/AverageCounter));
                             CIPrice(i-9,19) = RescaledSumOf; %%For Rescaled Range
                             StandardDev = ((TotalTickCounter1-(CumuTime/AverageCounter))^2);
                             CIPrice(i-9,20) =  sqrt(StandardDev/AverageCounter);
                             CIPrice(i-9,21) =  RescaledSumOf/(sqrt(StandardDev/AverageCounter));
                             CumulativeAverage = CumulativeAverage + (CumuTime/AverageCounter);
                             CIPrice(i-9,22) = CumulativeAverage;%%Cumulative OS Average from 18
                             CIPrice(i-9,23) = log(RescaledSumOf/(sqrt(StandardDev/AverageCounter)));
                             CIPrice(i-9,24) = log(CumulativeAverage);
                             CIPrice(i-9,25) = log(RescaledSumOf/(sqrt(StandardDev/AverageCounter)))/log(CumulativeAverage/2);   
                             CIPrice(i-9,26) = ABSPriceChange;


                        end



                    TotalTickCounter1 = 0;

                    DOWNCounterDC =  DOWNCounterDC + 1;
                    DCsize = DCsize + (((Price(i-1)- TotalMoveCounter1)./ Price(i-1))*100);
                    l = s;
                    tickcounter = 1;
                    DirectionalChange = DirectionalChange + 1;

                    %DOWN_LIMIT_PRICE = 0;]
                    
                    TradeMode = 0;

                 end  
                
                  
                 
                               
              
             
             elseif TotalMoveCounter1 == 0
            
                 TotalMoveCounter1 = lambda;
                 
             end
            
            
           
            
            mode = 1;
            SHORT_CUMU_CHANGE = 0;
            
        end
        
        
        
        
        
     elseif mode == 1
        
        
        if s > l %%For Short Trades, For Long trades in Contrarian strat.

            tickcounter = 0;
            l = s;
            
            ShortDifference = ((ShortEntry - Price(i))*LOT_SIZE)*CURRENCY_ADJUST;
            
            if  (((ShortDifference >= DOWN_LIMIT_PRICE)) || ((ShortDifference < -2000))) && TradeMode == 0
                
                SL_SHORTCOUNTER = 1;
                SL_SHORTPRICE = Price(i);
                
                
                
                if TradeMode == 0

                    %Contrarion Strat
                    if SL_SHORTCOUNTER == 1
                        
                        ShortExit = SL_SHORTPRICE;
                        ShortDifference = ((ShortEntry - ShortExit)*LOT_SIZE)*CURRENCY_ADJUST;
                        CIPrice(i-9,5) = Price(i);
                        CIPrice(i-9,6) = ((ShortEntry - ShortExit)*LOT_SIZE)*CURRENCY_ADJUST;%(TotalMoveCounter - Price(i))./ TotalMoveCounter)*100; % OS move  DOWNWARDMove
                        %ListOfTrades(ArtificialIndex1,3) = Account + ShortDifference;
                        
                    end
                    
                    %LongEntry = Price(i);
                    
                        if ShortEntry ~= 0 && ShortExit ~= 0

                        %Account = Account+ShortDifference;

                            ArtificialIndex1 = ArtificialIndex1 + 1;
                            ListOfTrades(ArtificialIndex1,1) = ShortDifference;
                            A_PERFORMANCE_TRADES(ArtificialIndex1,1) = ShortDifference;
                            
                            Account = Account + ShortDifference;
                            
                            
                            CUMU_RETURNS = CUMU_RETURNS + ShortDifference;
                            
                            ListOfTrades(ArtificialIndex1,3) = Account;
                            
                            A_PERFORMANCE_TRADES(ArtificialIndex1,2)= CUMU_RETURNS;
                            A_PERFORMANCE_TRADES_RET(ArtificialIndex1,1) = ((ShortDifference/Account)*100) - RISK_FREE_RATE;
                            ListOfTrades(ArtificialIndex1,2) = CUMU_RETURNS;
                           
                            if ShortDifference > 0
                                
                                PROFIT_TRADES = PROFIT_TRADES + 1;
                                
                            elseif ShortDifference < 0
                                
                                LOSS_TRADES = LOSS_TRADES + 1;
                                
                            end

                        elseif ShortEntry == 0 && ShortExit == 0

                            ListOfTrades(ArtificialIndex1,1) = 0;
                            %{
                            CUMU_RETURNS = CUMU_RETURNS + ShortDifference;
                            A_PERFORMANCE_TRADES(ArtificialIndex1,2)=CUMU_RETURNS;
                            A_PERFORMANCE_TRADES_RET(ArtificialIndex1,1) = ((CUMU_RETURNS/Account)*100) - RISK_FREE_RATE;
                            ListOfTrades(ArtificialIndex1,2) = CUMU_RETURNS;
                            ListOfTrades(ArtificialIndex1,3) = Account+ CUMU_RETURNS;
                            
                            if A_PERFORMANCE_TRADES(ArtificialIndex1,1) == 0
                                
                                A_PERFORMANCE_TRADES(ArtificialIndex1,1) = null;
                                
                            end
                                
                            
                            if ShortDifference > 0
                                
                                PROFIT_TRADES = PROFIT_TRADES + 1;
                                
                            elseif ShortDifference < 0
                                
                                LOSS_TRADES = LOSS_TRADES + 1;
                                
                            end
                            %}

                        end
                    
                        
                    %CIPrice(i-9,31) = abs((Price(i) - Price(i-1))./ Price(i-1));
                    %DIRECTIONAL_CHANGE_DOWNMOVE = abs((Price(i) - Price(i-1))./ Price(i-1));
                    %CIPrice(i-9,5) = Price(i);
                    %CIPrice(i-9,6) = (TotalMoveCounter - Price(i))*LOT_SIZE;%(TotalMoveCounter - Price(i))./ TotalMoveCounter)*100; % OS move  DOWNWARDMove
                    CIPrice(i-9,28) = CIPrice(i-9,6);
                    absPriceChange = absPriceChange + (abs((TotalMoveCounter - Price(i))./ TotalMoveCounter));
                    ABSPriceChange = absPriceChange/(absPriceChange-abs((Price(i) - TotalMoveCounter)./ TotalMoveCounter));
                    CIPrice(i-9,15) = absPriceChange;   

                     
                    %DOWN_LIMIT_PRICE = 0;]
                    ArtificialIndex = ArtificialIndex + 1;
                    Change(ArtificialIndex,1) =  abs((TotalMoveCounter - Price(i))./ TotalMoveCounter);


                    counter1 = i;  
                    TempCounter1 = counter1;

                    TotalTickCounter = (i - TempCounter);
                    CIPrice(i-9,13) = TotalTickCounter;

                    CumuTime = CumuTime + (TotalTickCounter);%*Time)
                    CIPrice(i-9,16) = CumuTime;


                    if CIPrice(i-9,16) ~= 0

                         CIPrice(i-9,17) = TotalTickCounter; %%Length Of Overshoot In tick count
                         AverageCounter = AverageCounter + 1;
                         CIPrice(i-9,18) = (CumuTime/AverageCounter); 
                         RescaledSumOf = abs(TotalTickCounter-(CumuTime/AverageCounter));
                         CIPrice(i-9,19) = RescaledSumOf;
                         StandardDev = ((TotalTickCounter-(CumuTime/AverageCounter))^2);
                         CIPrice(i-9,20) =  sqrt(StandardDev/AverageCounter); %Standard Deviation
                         CIPrice(i-9,21) =  RescaledSumOf/(sqrt(StandardDev/AverageCounter)); %R/S
                         CumulativeAverage = CumulativeAverage + (CumuTime/AverageCounter);
                         CIPrice(i-9,22) = CumulativeAverage;%%Cumulative OS Average from 18
                         CIPrice(i-9,23) = log(RescaledSumOf/(sqrt(StandardDev/AverageCounter)));
                         CIPrice(i-9,24) = log(CumulativeAverage);
                         CIPrice(i-9,25) = log(RescaledSumOf/(sqrt(StandardDev/AverageCounter)))/log(CumulativeAverage/2);
                         CIPrice(i-9,26) = ABSPriceChange;


                    end

                    TotalTickCounter = 0;
                    UPCounterDC = UPCounterDC + 1;
                    l = s;
                    DirectionalChange = DirectionalChange + 1;
                    DCsize = DCsize + (((TotalMoveCounter - Price(i-1))./ Price(i-1))*100);
                    
                    TradeMode = 1;

                end  
                          
            end
            

        elseif changeInPrice1 >= lambda  %% This will END the short trade, marking a DC in the opposite direction, LONG Trade in Contrarian
            
            
                      
            
            TotalMoveCounter1 = Price(i);
            CIPrice(i-9,8) = abs(changeInPrice2); % Part of Overshoot
            %CIPrice(i-9,9) = abs(changeInPrice2) - lambda;
            CIPrice(i-9,10) = Price(i);
            LongEntry = Price(i);
            
            if SET_FRACTAL == 0

                UP_LIMIT_PRICE = (((abs(changeInPrice1/100))*DEFAULT_FRACTAL)*LOT_SIZE)*CURRENCY_ADJUST;
                LongDCOvershoot = 0;%((changeInPrice1 - lambda)*DEFAULT_FRACTAL)-UP_LIMIT_PRICE;
                CIPrice(i-9,9) = (((abs(changeInPrice1/100))*DEFAULT_FRACTAL)*LOT_SIZE)*CURRENCY_ADJUST;

            elseif SET_FRACTAL ~= 0

                UP_LIMIT_PRICE = (((abs(changeInPrice1/100))*SETFRACTAL)*LOT_SIZE)*CURRENCY_ADJUST;
                LongDCOvershoot = 0;%((changeInPrice1 - lambda)*SETFRACTAL)-UP_LIMIT_PRICE;
                CIPrice(i-9,9) = (((abs(changeInPrice1/100))*SETFRACTAL)*LOT_SIZE)*CURRENCY_ADJUST;

            end
                    
            
            CIPrice(i-9,31) = abs((Price(i) - Price(i-1)))*LOT_SIZE;%abs((Price(i) - Price(i-1))./ Price(i-1));
            DIRECTIONAL_CHANGE_DOWNMOVE = abs((Price(i) - Price(i-1))./ Price(i-1));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if TradeMode == 0

                    %Contrarion Strat
                     
                    ShortExit = Price(i);
                    ShortDifference = ((ShortEntry - ShortExit)*LOT_SIZE)*CURRENCY_ADJUST; %%%%%//////////////////////
                    CIPrice(i-9,5) = Price(i);
                    CIPrice(i-9,6) = ((ShortEntry - ShortExit)*LOT_SIZE)*CURRENCY_ADJUST;%(TotalMoveCounter - Price(i))./ TotalMoveCounter)*100; % OS move  DOWNWARDMove

                                                          
                    SL_SHORTCOUNTER = 0;
                    
                    
                    %CIPrice(i-9,5) = Price(i);
                    %CIPrice(i-9,6) = (TotalMoveCounter - Price(i))*LOT_SIZE;%(TotalMoveCounter - Price(i))./ TotalMoveCounter)*100; % OS move  DOWNWARDMove
                    CIPrice(i-9,28) = CIPrice(i-9,6);
                    absPriceChange = absPriceChange + (abs((TotalMoveCounter - Price(i))./ TotalMoveCounter));
                    ABSPriceChange = absPriceChange/(absPriceChange-abs((Price(i) - TotalMoveCounter)./ TotalMoveCounter));
                    CIPrice(i-9,15) = absPriceChange;   
                    %ListOfTrades(ArtificialIndex1,3) = Account+ ShortDifference;
                    
                        if ShortEntry ~= 0 && ShortExit ~= 0

                        %Account = Account+ShortDifference;

                            ArtificialIndex1 = ArtificialIndex1 + 1;
                            ListOfTrades(ArtificialIndex1,1) = ShortDifference;
                            A_PERFORMANCE_TRADES(ArtificialIndex1,1) = ShortDifference;
                            
                            Account = Account + ShortDifference;
                            ListOfTrades(ArtificialIndex1,3) = Account;
                            
                            CUMU_RETURNS = CUMU_RETURNS + ShortDifference;
                            A_PERFORMANCE_TRADES(ArtificialIndex1,2)=CUMU_RETURNS;
                            A_PERFORMANCE_TRADES_RET(ArtificialIndex1,1) = ((ShortDifference/Account)*100) - RISK_FREE_RATE;
                            ListOfTrades(ArtificialIndex1,2) = CUMU_RETURNS;
                           
                            if ShortDifference > 0
                                
                                PROFIT_TRADES = PROFIT_TRADES + 1;
                                
                            elseif ShortDifference < 0
                                
                                LOSS_TRADES = LOSS_TRADES + 1;
                                
                            end

                        elseif ShortEntry == 0 && ShortExit == 0

                            ListOfTrades(ArtificialIndex1,1) = 0;
                            
                            CUMU_RETURNS = CUMU_RETURNS + ShortDifference;
                            A_PERFORMANCE_TRADES(ArtificialIndex1,2)=CUMU_RETURNS;
                            ListOfTrades(ArtificialIndex1,2) = CUMU_RETURNS;
                            A_PERFORMANCE_TRADES_RET(ArtificialIndex1,1) = ((CUMU_RETURNS/Account)*100) -RISK_FREE_RATE;
                            
                            ListOfTrades(ArtificialIndex1,3) = Account+ CUMU_RETURNS;
                            
                            if A_PERFORMANCE_TRADES(ArtificialIndex1,1) == 0
                                
                                A_PERFORMANCE_TRADES(ArtificialIndex1,1) = null;
                                
                            end
                                
                            
                            if ShortDifference > 0
                                
                                PROFIT_TRADES = PROFIT_TRADES + 1;
                                
                            elseif ShortDifference < 0
                                
                                LOSS_TRADES = LOSS_TRADES + 1;
                                
                            end

                        end

                     
                    %DOWN_LIMIT_PRICE = 0;]
                    ArtificialIndex = ArtificialIndex + 1;
                    Change(ArtificialIndex,1) =  abs((TotalMoveCounter - Price(i))./ TotalMoveCounter);


                    counter1 = i;  
                    TempCounter1 = counter1;

                    TotalTickCounter = (i - TempCounter);
                    CIPrice(i-9,13) = TotalTickCounter;

                    CumuTime = CumuTime + (TotalTickCounter);%*Time)
                    CIPrice(i-9,16) = CumuTime;


                    if CIPrice(i-9,16) ~= 0

                         CIPrice(i-9,17) = TotalTickCounter; %%Length Of Overshoot In tick count
                         AverageCounter = AverageCounter + 1;
                         CIPrice(i-9,18) = (CumuTime/AverageCounter); 
                         RescaledSumOf = abs(TotalTickCounter-(CumuTime/AverageCounter));
                         CIPrice(i-9,19) = RescaledSumOf;
                         StandardDev = ((TotalTickCounter-(CumuTime/AverageCounter))^2);
                         CIPrice(i-9,20) =  sqrt(StandardDev/AverageCounter); %Standard Deviation
                         CIPrice(i-9,21) =  RescaledSumOf/(sqrt(StandardDev/AverageCounter)); %R/S
                         CumulativeAverage = CumulativeAverage + (CumuTime/AverageCounter);
                         CIPrice(i-9,22) = CumulativeAverage;%%Cumulative OS Average from 18
                         CIPrice(i-9,23) = log(RescaledSumOf/(sqrt(StandardDev/AverageCounter)));
                         CIPrice(i-9,24) = log(CumulativeAverage);
                         CIPrice(i-9,25) = log(RescaledSumOf/(sqrt(StandardDev/AverageCounter)))/log(CumulativeAverage/2);
                         CIPrice(i-9,26) = ABSPriceChange;


                    end

                    TotalTickCounter = 0;
                    UPCounterDC = UPCounterDC + 1;
                    l = s;
                    DirectionalChange = DirectionalChange + 1;
                    DCsize = DCsize + (((TotalMoveCounter - Price(i-1))./ Price(i-1))*100);
                    TradeMode = 1;

            end  
            
            
                                 
            
            
            
            %Phi(ArtificialIndex,2) = abs((TotalMoveCounter - Price(i-1))./ TotalMoveCounter);
            %TotalMoveCounter = Price(i-1);
            
            
           
            mode = 0;
            LONG_CUMU_CHANGE = 0;
            
        end
        
        
       
                        
        
        
    end
    
    PeriodCounter = i - alpha;
    
     if PeriodCounter == 10000 %%This piece of code divides the range of data by PeriodCounter and recalculates the Hurstexponent

        
        
        CIPrice(i-9,29) = log(RescaledSumOf/(sqrt(StandardDev/AverageCounter)))/log(CumulativeAverage/2);
        CIPrice(i-9,33) = (2 - (log(RescaledSumOf/(sqrt(StandardDev/AverageCounter)))/log(CumulativeAverage/2))); % D= 2-H
        CIPrice(i-9,34) = (2^(((2*(log(RescaledSumOf/(sqrt(StandardDev/AverageCounter)))/log(CumulativeAverage/2)))-1))) - 1; % C = 2^(2H-1) -1
        
        
        
        SHARPE_INDEX = SHARPE_INDEX + 1;
        SHARPE_MEAN = mean(A_PERFORMANCE_TRADES);
        SHARPE_SDEV = std(A_PERFORMANCE_TRADES);
        SHARPE(SHARPE_INDEX,1) = SHARPE_MEAN/SHARPE_SDEV; 
        
        LIST_OF_FRACTALS(SHARPE_INDEX,1)= log(RescaledSumOf/(sqrt(StandardDev/AverageCounter)))/log(CumulativeAverage/2);
        LIST_OF_FRACTALS(SHARPE_INDEX,2)=(2 - (log(RescaledSumOf/(sqrt(StandardDev/AverageCounter)))/log(CumulativeAverage/2))); % D= 2-H
        LIST_OF_FRACTALS(SHARPE_INDEX,3)=(2^(((2*(log(RescaledSumOf/(sqrt(StandardDev/AverageCounter)))/log(CumulativeAverage/2)))-1))) - 1; % C = 2^(2H-1) -1
        
        SHARPE_MEAN =0;
        SHARPE_SDEV =0;
        
        FRACTAL_INDEX = FRACTAL_INDEX + 1;
        FRACTAL_CUMULATIVE = FRACTAL_CUMULATIVE + (2 - (log(RescaledSumOf/(sqrt(StandardDev/AverageCounter)))/log(CumulativeAverage/2)));
        FRACTALS(FRACTAL_INDEX,1) = FRACTAL_CUMULATIVE / FRACTAL_INDEX;
        FRACTAL_AVERAGE02 = FRACTAL_CUMULATIVE / FRACTAL_INDEX;
        
        SETFRACTAL = (2- (log(RescaledSumOf/(sqrt(StandardDev/AverageCounter)))/log(CumulativeAverage/2)));
        
        %A_Sharpe = sharpe(CIPrice(1:ArtificialIndex1,6),0);
        
        PeriodCounter = 0;
        alpha = alpha + 10000;
        CumuTime = 0;
        AverageCounter = 0;
        CumulativeAverage = 0;
        
       

     end
    
    DCcounter = UPCounterDC + DOWNCounterDC;
    counter = counter+1;
    %{
    grid on
    figure(1);
    %subplot(2,1,1)
    plot(Price(10:i),'--s');
    hold on
    pause(0.00005);
    
    for j = 10: length(Price)
        
        if (CIPrice(i-9,2) ~= 0)
            
            plot(i-9,Price(i),'v','MarkerFaceColor','g');
            plot(i-10,Price(i-1),'v','MarkerFaceColor','g');
            
            
        elseif (CIPrice(i-9,8) ~= 0)
            
            plot(i-9,Price(i),'^','MarkerFaceColor','r');
            plot(i-10,Price(i-1),'^','MarkerFaceColor','r');
            
        end
        
            
    end
   %}
   Sum = sum(ListOfTrades);
   
   
   
   
            
end            

%A_PERFORMANCE_TRADES_RET(A_PERFORMANCE_TRADES == 0) = [];

Sharpe(1:ArtificialIndex1,1) = A_PERFORMANCE_TRADES_RET(1:ArtificialIndex1,1);
SHARPE_AVERAGE = mean(A_PERFORMANCE_TRADES_RET(1:ArtificialIndex1,1));
SHARPE_STDEV = std(A_PERFORMANCE_TRADES_RET(1:ArtificialIndex1,1));
SHARPE = SHARPE_AVERAGE/SHARPE_STDEV;

A_Sharpe = sharpe(A_PERFORMANCE_TRADES(1:ArtificialIndex1,1),0);



plot(Price(1:end),'--s');

grid on           
            
            
            