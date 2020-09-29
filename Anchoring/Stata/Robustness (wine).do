** Regression Table for market information (Table 2) **
eststo wine_0: quietly regress WTA_initial anchor if wine_type == 0
eststo wine_1: quietly regress WTA_initial anchor if wine_type == 1
eststo wine_2: quietly regress WTA_initial anchor if wine_type == 2
eststo wine_3: quietly regress WTA_initial anchor if wine_type == 3
esttab wine_0 wine_1 wine_2 wine_3, ///
p r2 label nonumber noomitted nobaselevels b(2) obslast