

 alter function
  dbo.udf_WeekBeginEndDates( @DateFrom datetime2(7),
                         @DateTo datetime2(7) )
returns @Result table( Year int, WeekNumber int, BeginDate datetime2(0), EndDate datetime2(0) )
as
begin

  declare @Date date;
  set @Date = dateadd(d, - (datepart(dw, @DateFrom) - 1), @DateFrom);

  while @Date < @DateTo
  begin

    insert into @Result
    values ( Year(@Date), datepart(ISO_WEEK, @Date), @Date, dateadd(d, 7, @Date) );

    set @Date = dateadd(d, 7, @Date);

  end;

  return;

end;

