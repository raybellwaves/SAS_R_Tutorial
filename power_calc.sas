* Taken from https://github.com/sassoftware/sas-prog-for-r-users/blob/master/code/SP4R01d01.sas;
* https://stats.idre.ucla.edu/other/gpower/multiple-regression-power-analysis/;
/*Sampling continuos data*/
proc iml;
   nRep=1000;
   call randseed(112358);

   n=30;
   mean={20, 5, 10};
   corr={1 .2 .2, .2 1 .2, .2 .2 1};
   var={5, 3, 7};
   beta={ 1, 2, .5};
   resvar=14;

   sddiag=diag(sqrt(var));
   cov=sddiag * corr * sddiag;

   x=randNormal(n*nRep,mean,cov);

   yPred=x * beta;
   error=randfun(n*nrep,"Normal",0,sqrt(resvar));
   y=yPred + error;

   temp=repeat((1:nrep)`,1,n);
   iteration=colvec(temp);

   sampleData=iteration || x || y;
   create temp from sampleData [colname={iteration x c1 c2 y}];
   append from sampleData;
   close temp;
   store;
quit;

proc glm data=temp noprint outstat=regResults;
   by iteration;
   model y=x c1 c2;
run;quit;

proc iml;
   use regResults;
   read all var {prob} where(_SOURCE_='X' & _TYPE_='SS3') into prob;
   close regResults;

   significant=prob < .05; power=significant[:,];
   print power;
quit;
