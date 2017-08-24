

declare @i1 table ( k nvarchar(30), v float );
declare @i2 table ( k nvarchar(30), v float );

insert into @i1 values(1, 0);
insert into @i1 values(2, 2);
insert into @i1 values(3, 3);
insert into @i1 values(4, 1);
insert into @i1 values(5, 0);
insert into @i2 values(1, 0);
insert into @i2 values(2,-2);
insert into @i2 values(3,-3);
insert into @i2 values(4,-1);
insert into @i2 values(5, 1);

declare @i1_avg float,
        @i2_avg float,
        @i1_std float,
        @i2_std float,
        @n int;

select @i1_avg = avg(v), @i1_std = stdev(v) from @i1;
select @i2_avg = avg(v), @i2_std = stdev(v) from @i2;

select @n = count(1) from @i1 i1 full join @i2 i2 on i1.k = i2.k;

select  @i1_avg,
        @i2_avg,
        @i1_std,
        @i2_std;

declare @corr float;

select @corr = (sum((isnull(i1.v, 0) - @i1_avg) * (isnull(i2.v, 0) - @i2_avg)) / (@n - 1))
                / (@i1_std * @i2_std )
from @i1 i1
  full join @i2 i2 on i1.k = i2.k;


select @corr;