
declare @minLength int = 30,
        @speedLim decimal(18, 4) = 1;


declare @result table( BiggerThanLimit bit, ID_Articul uniqueidentifier );

declare @bLess uniqueidentifier, @bEqBigger uniqueidentifier;
set @bLess = newid();
set @bEqBigger = newid();


declare c cursor local fast_forward for
  select ID_Articul,
         WeekNumber,
         case when [Value] < @speedLim then @bLess
                                       else @bEqBigger
                                       end
  from dbo._Report1
  order by ID_Articul, WeekNumber;

open c;

declare @prev_Articul uniqueidentifier = newid(),
        @prev_WeekNumber int = 1000,
        @prev_Value uniqueidentifier = newid();

declare @cur_Articul uniqueidentifier,
        @cur_WeekNumber int,
        @cur_Length int,
        @cur_Value uniqueidentifier;

fetch next from c into @cur_Articul, @cur_WeekNumber, @cur_Value;

while @@FETCH_STATUS = 0
begin

  -- условия завершения последовательности
  if   @prev_Articul != @cur_Articul
    or @prev_WeekNumber + 1 != @cur_WeekNumber
    or @prev_Value != @cur_Value
  begin

    -- отбор результата по длительности
    if @cur_Length >= @minLength
    begin

      insert into @result values(
        iif( @prev_Value = @bEqBigger, 1, 0),
        @prev_Articul );

    end;

    set @cur_Length = 1;

  end
  else
  begin

    set @cur_Length = @cur_Length + 1;

  end;

  set @prev_Articul = @cur_Articul;
  set @prev_Value = @cur_Value;
  set @prev_WeekNumber = @cur_WeekNumber;

  fetch next from c into @cur_Articul, @cur_WeekNumber, @cur_Value;

end;


select * from @result r left join dbo.Articuls a on a.ID_Articul = r.ID_Articul;