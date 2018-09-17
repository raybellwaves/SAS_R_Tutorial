/*Taken from https://github.com/sassoftware/sas-prog-for-r-users/blob/master/code/SP4R01d01.sas*/
/***************************************************************************************************/
/*Call R from SAS/IML*/
proc iml;
   call ExportDataSetToR("work.birth","birth");

     submit / r;
	      library(randomForest)
		    rf = randomForest(BWT ~ SMOKE + HT + LWT + PTL, data=birth,ntree=200,importance=TRUE)
		    summary(rf)
		    actual = birth$BWT
		    pred = predict(rf,data=birth)
		    actual.pred = cbind(actual,pred)
		    colnames(actual.pred) <- c("Actual","Predicted")
     endsubmit;

   call ImportDataSetFromR("Rdata","actual.pred");
quit;
