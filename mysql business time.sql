delimiter $$
create function business_time
(
startDate datetime,
finishDate datetime,
workStart time,
workFinish time
)
returns int
deterministic
begin
	declare temp int;
    declare firstDay date;
    declare lastDay date;
    declare startTime time;
    declare finishTime time;
    declare dailyWorkTime int;
    declare currentDate date;
    declare lastDate date;
    
	set temp=0;
    select cast(startDate as date) into firstDay;
    select cast(finishDate as date) into lastDay;
    select time(startDate) into startTime;
    select time(finishDate) into finishTime;
    select timestampdiff(minute,workStart,workFinish) into dailyWorkTime;
    
    if (startTime<workStart) then
		set startTime=workStart;
    end if;
    
    if (finishTime>workFinish) then
		set finishTime=workFinish;
	end if;
    
    if (finishTime<workStart) then
		set finishTime=workStart;
	end if;
    
    if (startTime>workFinish) then
		set startTime=workFinish;
	end if;
    
    set currentDate=firstDay;
    set lastDate=lastDay;
    
    while (currentDate<=lastDate) do
		if (currentDate!=firstDay and currentDate!=lastDay) then
			set temp=temp+dailyWorkTime;
         elseif (currentDate=firstDay and currentDate!=lastDay)  then
			set temp=temp+timestampdiff(minute,startTime,workFinish);
		elseif (currentDate!=firstDay and currentDate=lastDay) then
			set temp=temp+timestampdiff(minute,workStart,finishTime);
		elseif (currentDate=firstDay and currentDate=lastDay) then
			set temp=timestampdiff(minute,startTime,finishTime);
		end if;
        select date_add(currentDate, interval 1 day) into currentDate;
    end while;
    
return temp;
end$$