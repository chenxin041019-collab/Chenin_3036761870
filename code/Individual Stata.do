*数据处理环节
import delimited "/Users/chenxin/Desktop/01_DID/data/public.csv", varnames(1) 
gen bk = (chain ==1)
gen kfc = (chain ==2)
gen roys = (chain ==3)
gen nj = (state ==1)
*构造FTE
gen fte1 = nmgrs + empft + 0.5 * emppt
label var fte1 "Wave1 full‑time equivalent employment"
gen fte2 = nmgrs2 + empft2 + 0.5 * emppt2
label var fte2 "Wave2 full‑time equivalent employment"
replace fte2 = 0 if status2 ==4
*构造demp
gen demp = fte2 - fte1
label var demp "Change in FTE employment (fte2-fte1)"
*构造nj gap
gen gap = 0
replace gap = (5.05 - wage_st)/wage_st  if state ==1 & wage_st <5.05
label var gap "Wage gap: proportional required wage increase"
*构造价格变量
gen pmeal = psoda + pfry + pentree
gen pmeal2 = psoda2 + pfry2 + pentree2
gen dln_pmeal = ln(pmeal2) - ln(pmeal)
label var dln_pmeal "Log change of full‑meal price"
preserve
*样本筛选
keep if demp ~=. & wage_st ~=. & wage_st2 ~=.
count
*Table4
reg demp nj, robust
reg demp nj bk kfc roys co_owned, robust
reg demp gap, robust
reg demp gap bk kfc roys co_owned, robust
reg demp gap bk kfc roys co_owned southj centralj northj pa1 pa2, robust
restore
preserve
*Table5
gen fte2_rob = fte2
replace fte2_rob = 0 if status2 ==3
gen demp_rob = fte2_rob - fte1
keep if demp_rob ~=. & wage_st ~=. & wage_st2 ~=.
reg demp_rob gap bk kfc roys co_owned, robust
restore
preserve
*Table 7
keep if dln_pmeal ~=. & gap~=. & bk~=. &kfc~=. & roys~=. & co_owned~=.
count
reg dln_pmeal nj bk kfc roys co_owned, robust
reg dln_pmeal gap bk kfc roys co_owned southj centralj northj pa1 pa2, robust
restore
*描述性统计
summarize fte1 fte2 demp nj gap wage_st wage_st2 dln_pmeal
bysort nj: summarize fte1 fte2 demp wage_st wage_st2
*生成NJ内部工资分组
gen wage_group = .
replace wage_group =1 if nj==1 & wage_st==4.25
replace wage_group =2 if nj==1 & wage_st>4.25 & wage_st<5.00
replace wage_group =3 if nj==1 & wage_st>=5.00
replace wage_group =0 if nj==0 // PA组
*计算每组fte1 fte2 demp的均值
*table3
tabstat fte1 fte2 demp, by(wage_group) statistics(n mean sd)
replace wage_group =0 if nj==0 
tabstat fte1 fte2 demp, by(wage_group) statistics(n mean sd)
preserve
*Table4
keep if demp ~=. & wage_st ~=. & wage_st2 ~=.
reg demp nj, robust
reg demp nj bk kfc roys co_owned, robust
reg demp gap, robust
reg demp gap bk kfc roys co_owned, robust
reg demp gap bk kfc roys co_owned southj centralj northj pa1 pa2, robust
restore
preserve
*Table 5
keep if demp ~=. & wage_st ~=. & wage_st2 ~=.
gen fte2_r2 = fte2
replace fte2_r2 =0 if status2 ==3
gen demp_r2 = fte2_r2 - fte1
reg demp_r2 gap bk kfc roys co_owned, robust
gen fte1_nomgr = empft +0.5*emppt
gen fte2_nomgr = empft2 +0.5*emppt2
replace fte2_nomgr =0 if status2==4
gen demp_nomgr = fte2_nomgr - fte1_nomgr
reg demp_nomgr gap bk kfc roys co_owned, robust
gen fte1_w4 = nmgrs + empft + 0.4*emppt
gen fte2_w4 = nmgrs2 + empft2 +0.4*emppt2
replace fte2_w4=0 if status2==4
gen demp_w4 = fte2_w4-fte1_w4
reg demp_w4 gap bk kfc roys co_owned, robust
gen fte1_w6 = nmgrs + empft + 0.6*emppt
gen fte2_w6 = nmgrs2 + empft2 +0.6*emppt2
replace fte2_w6=0 if status2==4
gen demp_w6 = fte2_w6-fte1_w6
reg demp_w6 gap bk kfc roys co_owned, robust
reg demp gap bk kfc roys co_owned if ncalls <=2, robust
reg demp gap bk kfc roys co_owned [aweight=fte1], robust
preserve
keep if nj==0
gen fake_gap = (5.05 - wage_st)/wage_st
reg demp fake_gap bk kfc roys co_owned, robust
restore
restore
preserve
*Table7
keep if dln_pmeal ~=. & gap~=. & bk~=. &kfc~=. & roys~=. & co_owned~=.
count
reg dln_pmeal nj, robust
reg dln_pmeal nj bk kfc roys co_owned, robust
reg dln_pmeal gap, robust 
reg dln_pmeal gap bk kfc roys co_owned, robust 
reg dln_pmeal gap bk kfc roys co_owned southj centralj northj pa1 pa2, robust 
restore
ssc install estout
preserve
*Table1
keep if demp ~=. & wage_st ~=. & wage_st2 ~=.
eststo clear
eststo: reg demp nj, robust
eststo: reg demp nj bk kfc roys co_owned, robust
eststo: reg demp gap, robust
eststo: reg demp gap bk kfc roys co_owned, robust
eststo: reg demp gap bk kfc roys co_owned southj centralj northj pa1 pa2, robust
esttab using table4.rtf, replace se star(* 0.1 **0.05 ***0.01)
restore
export excel using "/Users/chenxin/Desktop/Processed data.xls"
label define njlab 1 "NJ" 0 "PA"
label values nj njlab
count 
count if nj==1 
count if nj==0 
tab status2 nj, col
count if status2 ==4 
count if status2 ==2 
count if status2 ==3 
count if status2 ==. & nj~=. 
count if status2 ==1 
bysort nj: summ fte1 fte2 demp wage_st wage_st2 gap
* Example: test pre‑policy FTE (fte1)
ttest fte1, by(nj)
* post‑policy FTE (fte2)
ttest fte2, by(nj)
* change in FTE employment demp = fte2‑fte1
ttest demp, by(nj)
* wave‑1 starting wage
ttest wage_st, by(nj)
* wave‑2 starting wage
ttest wage_st2, by(nj)
* wage gap variable
ttest gap, by(nj)
*柱状图
twoway 
hist wage_st if nj==1, percent width(0.1) start(4.25) color(black)
hist wage_st if nj==0, percent width(0.1) start(4.25) color(gs12), 
* February (wage_st)
twoway 
* November (wage_st2)
twoway 
* February (wage_st)
twoway 
hist wage_st if nj==1, percent width(0.1) start(4.25) color(black)
hist wage_st if nj==0, percent width(0.1) start(4.25) color(gs12), 
* November (wage_st2)
twoway 
hist wage_st2 if nj==1, percent width(0.1) start(4.25) color(black)
hist wage_st2 if nj==0, percent width(0.1) start(4.25) color(gs12),
hist wage_st2 if nj==1, percent width(0.1) start(4.25) color(black)
hist wage_st2 if nj==0, percent width(0.1) start(4.25) color(gs12),
hist wage_st2 if nj==1, percent width(0.1) start(4.25) color(black)
twoway 
hist wage_st if nj==0, percent width(0.1) start(4.25) color(gs12), 
hist wage_st if nj==1, percent width(0.1) start(4.25) color(black)
* 计算NJ整体demp加权均值
summarize demp if nj==1
local mean_nj = r(mean)
summarize demp if nj==0
local mean_pa = r(mean)
local did = `mean_nj' - `mean_pa'
display "NJ平均就业变化: " `mean_nj'
display "PA平均就业变化: " `mean_pa'
display "简单DiD = " `did'
 *Table6
 replace gap = 0 if missing(gap)
 gen frac_full  = empft / (empft + emppt)
 gen frac_full2 = empft2 / (empft2 + emppt2)
 gen d_fracfull = frac_full2 - frac_full
 gen d_hrsopen = hrsopen2 - hrsopen
 gen d_nregs11 = nregs112 - nregs11
 gen d_meals = meals2 - meals
 gen d_inctime = inctime2 - inctime
 gen d_firstinc = firstin2 - firstinc
 gen slope  = firstinc / inctime
 gen slope2 = firstin2 / inctime2
 gen d_slope = slope2 - slope
 global chain_ctrl   bk kfc rr
 global firm_ctrl    co_owned
 global region_ctrl  southj centralj northj pa2
 capture ssc install eststo
 eststo coliv_1: reg d_fracfull nj $chain_ctrl $firm_ctrl, robust
 eststo colv_1:  reg d_fracfull gap $chain_ctrl $firm_ctrl, robust
 eststo colvi_1: reg d_fracfull gap $chain_ctrl $firm_ctrl $region_ctrl, robust
 reg d_fracfull gap chain co_owned southj centralj northj, robust
 estimates store model1
 reg d_hrsopen gap chain co_owned southj centralj northj, robust
 estimates store model2
 reg d_nregs11 gap chain co_owned southj centralj northj, robust
 estimates store model2
 reg d_meals gap chain co_owned southj centralj northj, robust
 estimates store model2
 reg d_inctime gap chain co_owned southj centralj northj, robust
 estimates store model2
 reg d_firstinc gap chain co_owned southj centralj northj, robust
 estimates store model2
 reg d_slope gap chain co_owned southj centralj northj, robust
 estimates store model2
 reg d_fracfull gap bk kfc roys co_owned southj centralj northj, robust
 reg d_hrsopen gap bk kfc roys co_owned southj centralj northj, robust
 reg d_nregs11 gap bk kfc roys co_owned southj centralj northj, robust
 reg d_meals gap bk kfc roys co_owned southj centralj northj, robust
 reg d_inctime gap bk kfc roys co_owned southj centralj northj, robust
 reg d_firstinc gap bk kfc roys co_owned southj centralj northj, robust
 reg d_slope gap bk kfc roys co_owned southj centralj northj, robust
 *Table7
 gen gap_coowned = gap * co_owned
 gen d_fte = fte2 - fte
 gen d_fte = fte2 - fte1
 gen gap = 0
 replace gap = (5.05 - wage_st)/wage_st if state==1 & wage_st <5.05
 gen gap_coowned = gap * co_owned
 drop gap_coowned
 gen gap_coowned = gap * co_owned
  gen gap1 = 0
   replace gap1 = (5.05 - wage_st)/wage_st if state==1 & wage_st <5.05
   drop gap_coowned
   gen gap1_coowned = gap1 * co_owned
   reg d_fte gap1 co_owned gap1_coowned bk kfc roys southj centralj northj, robust
   reg d_fte gap1 bk kfc roys southj centralj northj if co_owned==1, robust
   reg d_fte gap1 bk kfc roys southj centralj northj if co_owned==0, robust
   reg dln_pmeal gap1 co_owned gap1_coowned bk kfc roys southj centralj northj, robust
   )))))''''')))))))))))))))))))))))))))))))))))))))))))))))))])))))))))))))"
