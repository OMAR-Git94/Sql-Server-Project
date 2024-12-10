use homeutiltyprovider
go
declare @i int, @r int
exec @r = spinsertworkareas 'electronics work', @i output
if @r = 0
	select @i
exec @r = spinsertworkareas 'electricl work', @i output
if @r = 0
	select @i
exec @r = spinsertworkareas 'house maintenance', @i output
if @r = 0
	select @i
exec @r =  spinsertworkareas 'plumbing', @i output
if @r = 0
	select @i
exec @r = spinsertworkareas 'gas service', @i output
if @r = 0
	select @i
select * from workareas
go
--- table 2 ---
declare @r int
exec @r=  spinsertworkers 101,'md.rahim','01920151533',780.00
if @r = 0
	print 'inserted'
exec @r=  spinsertworkers 102,'rakib','01629415557',820.00
if @r = 0
	print 'inserted'
exec @r=  spinsertworkers 103,'biplop','01811695986',680.00
if @r = 0
	print 'inserted'
exec @r=   spinsertworkers 104,'saju','01587032087',500.00
if @r = 0
	print 'inserted'
exec @r=  spinsertworkers 105,'pavel','01642405277',750.00
if @r = 0
	print 'inserted'
exec spinsertworkers 106,'sohan','01908355205',885.00
if @r = 0
	print 'inserted'
exec spinsertworkers 107,'kafi','01571282593',880.00
if @r = 0
	print 'inserted'
select* from workers
go
---- table 03----
exec spinsertworkerareas 101,3
go 
exec spinsertworkerareas 101,2
go 
exec spinsertworkerareas 102,1
go 
exec spinsertworkerareas 103,2
go 
exec spinsertworkerareas 103,5
go 
exec spinsertworkerareas 104,4
go 
exec spinsertworkerareas 105,3
go 
exec spinsertworkerareas 106,2
go 
exec spinsertworkerareas 107,1
go 
exec spinsertworkerareas 105,5
go 
select* from workerareas

--- table 04--- 

exec spinsertworks 501,'md.rahim','12, mirpur-1',1,
'electronics repair ','2022-01-01','2022-08-04'
go 
exec spinsertworks 502,'rakib','15, dhanmondi',2,
'electric wiring ','2022-01-06','2022-5-04'
go 
exec spinsertworks 503,'biplop','44,kallanpur',3,
'house recycling','2022-02-05','2022-9-04'
go 
exec spinsertworks 504,'saju','33,syamoli',4,
'water line replace ','2022-03-01','2022-7-04'
go 
exec spinsertworks 505,'pavel','15, farmgate',5,
'swage pipe replacementnew electic line','2022-04-01','2022-06-04'
go 
exec spinsertworks 506,'sohan','15, sahbag',5,
'new gas line','2022-04-01',null
go 
select* from works
go
select* from workerdetails
-------- table 05 -
declare @h1 int , @h2 int
set @h1 =datediff (hour, '2022-01-01','2022-08-04')
set @h2 = datediff (hour, '2022-01-01','2022-08-04')*900
exec spinsertworkerpayments  501, 101,@h1 ,@h2
exec spinsertworkerpayments  502, 102,@h1 ,@h2
exec spinsertworkerpayments  503, 102,@h1 ,@h2
exec spinsertworkerpayments  504, 103,@h1 ,@h2
exec spinsertworkerpayments  505, 104,@h1 ,@h2
go 
--------------------view ---------------------
select * from vdetails
go
select * from workerdetails
go
select * from worksdetails
go
select * from vworkall
go
------------------------udf --------------------
select * from fnworkerlist(1)
go
select * from fnworksbyid(501)
go
select * from fnworksbyworkername('md.rahim')
go
/*

 * --queries 

 **/
--1 join inner 
-------------------------------------------------------------------------
select        wo.workername, wo.phone, wo.payrate, woa.skill, w.customename, w.customeraddress, wp.totalworkhour, wp.totalpayment
from            workareas woa
inner join
                         workerareas wa on woa.workareaid = wa.areaid 
inner join
                         workerpayments wp on wa.workerid = wp.workerid 
inner join
                         workers wo on wa.workerid = wo.workerid and wp.workerid = wo.workerid 
inner join
                         works w on wa.areaid = w.workareaid and wp.workid = w.workid
go
--2 specific work
-----------------------------------------------
select        wo.workername, wo.phone, wo.payrate, woa.skill, w.customename, w.customeraddress, wp.totalworkhour, wp.totalpayment
from            workareas woa
inner join
                         workerareas wa on woa.workareaid = wa.areaid 
inner join
                         workerpayments wp on wa.workerid = wp.workerid 
inner join
                         workers wo on wa.workerid = wo.workerid and wp.workerid = wo.workerid 
inner join
                         works w on wa.areaid = w.workareaid and wp.workid = w.workid
where woa.skill = 'electronics work'
-- 3 specific worker
--------------------------------------------------------------------
select        wo.workername, wo.phone, wo.payrate, woa.skill, w.customename, w.customeraddress, wp.totalworkhour, wp.totalpayment
from            workareas woa
inner join
                         workerareas wa on woa.workareaid = wa.areaid 
inner join
                         workerpayments wp on wa.workerid = wp.workerid 
inner join
                         workers wo on wa.workerid = wo.workerid and wp.workerid = wo.workerid 
inner join
                         works w on wa.areaid = w.workareaid and wp.workid = w.workid
where wo.workername = 'md.rahim'
go
--4 outer 
-----------------------------------------------------------------------------------------------------------
select        wo.workerid, wo.workername, wo.phone, wo.payrate, wa.skill, w.customename, w.customeraddress, 
w.workdescription, w.startdate, w.endtime,   wp.totalworkhour,wp.totalpayment
                       
from            workers wo
inner join
                         workerareas woa on wo.workerid = woa.workerid 
inner join
                         workareas wa on woa.areaid = wa.workareaid 
left outer join
                         workerpayments wp on wo.workerid = wp.workerid 
left outer join
                         works w on wp.workid = w.workid and wa.workareaid = w.workareaid
--5 same with cte
------------------------------------
with cte as
(
select        wo.workerid, wo.workername, wo.phone, wo.payrate, wa.skill, woa.areaid, wa.workareaid
                       
from            workers wo
inner join
                         workerareas woa on wo.workerid = woa.workerid 
inner join
                         workareas wa on woa.areaid = wa.workareaid 
)
select cte.workername, cte.phone, cte.payrate, cte.skill, w.customename, w.customeraddress, wp.totalworkhour, wp.totalpayment
from cte 
left outer join
                         workerpayments wp on cte.workerid = wp.workerid 
left outer join
                         works w on wp.workid = w.workid and cte.workareaid = w.workareaid
--6 not matched for left join
-----------------------------------------------------------------------------------------------------------
select        wo.workerid, wo.workername, wo.phone, wo.payrate, wa.skill, w.customename, w.customeraddress, 
w.workdescription, w.startdate, w.endtime,   wp.totalworkhour,wp.totalpayment
                       
from            workers wo
inner join
                         workerareas woa on wo.workerid = woa.workerid 
inner join
                         workareas wa on woa.areaid = wa.workareaid 
left outer join
                         workerpayments wp on wo.workerid = wp.workerid 
left outer join
                         works w on wp.workid = w.workid and wa.workareaid = w.workareaid
where w.customename is null and wp.workid is null
go
--7 same with subquery
-----------------------------------------------------------------------------------------------------------
select        wo.workerid, wo.workername, wo.phone, wo.payrate, wa.skill, w.customename, w.customeraddress, 
w.workdescription, w.startdate, w.endtime,   wp.totalworkhour,wp.totalpayment
                       
from            workers wo
inner join
                         workerareas woa on wo.workerid = woa.workerid 
inner join
                         workareas wa on woa.areaid = wa.workareaid 
left outer join
                         workerpayments wp on wo.workerid = wp.workerid 
left outer join
                         works w on wp.workid = w.workid and wa.workareaid = w.workareaid
where wo.workerid not in (select workerid from workerpayments)
--8 aggregate
-----------------------------------------------------------------------------------------------------------
select        wo.workername, sum(wp.totalworkhour) 'totalhour', sum(wp.totalpayment) 'totalpayment'
from            workareas woa
inner join
                         workerareas wa on woa.workareaid = wa.areaid 
inner join
                         workerpayments wp on wa.workerid = wp.workerid 
inner join
                         workers wo on wa.workerid = wo.workerid and wp.workerid = wo.workerid 
inner join
                         works w on wa.areaid = w.workareaid and wp.workid = w.workid
group by wo.workername
--9 aggregate and having
------------------------------------------------------------------------------
select        wo.workername, sum(wp.totalworkhour) 'totalhour', sum(wp.totalpayment) 'totalpayment'
from            workareas woa
inner join
                         workerareas wa on woa.workareaid = wa.areaid 
inner join
                         workerpayments wp on wa.workerid = wp.workerid 
inner join
                         workers wo on wa.workerid = wo.workerid and wp.workerid = wo.workerid 
inner join
                         works w on wa.areaid = w.workareaid and wp.workid = w.workid
group by wo.workername
having wo.workername='rakib'
go
--10 windowing
---------------------------------------------------------------------------------------------
select        wo.workername, 
sum(wp.totalworkhour) over(order by wo.workerid) 'totalhour', 
sum(wp.totalpayment) over(order by wo.workerid) 'totalpayment',
row_number()  over(order by wo.workerid) 'rownum',
rank()  over(order by wo.workerid) 'rank',
dense_rank()  over(order by wo.workerid) 'denserank',
ntile(2)  over(order by wo.workerid) 'ntile (2)'
from            workareas woa
inner join
                         workerareas wa on woa.workareaid = wa.areaid 
inner join
                         workerpayments wp on wa.workerid = wp.workerid 
inner join
                         workers wo on wa.workerid = wo.workerid and wp.workerid = wo.workerid 
inner join
                         works w on wa.areaid = w.workareaid and wp.workid = w.workid
go
--11 -select case
--------------------------------------------------------------------
select customename, customeraddress, workdescription, startdate,
case
	when endtime is null then 'running'
	else cast(endtime as varchar)
end endtime
from works
