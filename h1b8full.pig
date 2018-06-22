h1b = load '/home/hduser/Downloads/h1bpig' using PigStorage('\t') as (sno, casestatus:chararray, employername, socname, jobtitle:chararray, position:chararray, wage:double, year:chararray, lat, log);

--h1b10 = limit h1b 10;

--dump h1b10;

h1bfilter = foreach h1b generate casestatus, jobtitle, position, wage, year;

--h1bfilter10 = limit h1bfilter 10;

--dump h1bfilter10;

csfilter = filter h1bfilter by LOWER(casestatus) == 'certified' OR LOWER(casestatus) == 'certified-withdrawn';

--csfilter20 = limit csfilter 20;

--dump csfilter20;

--describe csfilter;

--csfilter: {casestatus: chararray,jobtitle: chararray,position: chararray,wage: double,year: chararray}

fulltime = filter csfilter by LOWER(position) == 'y';

--fulltime5 = limit fulltime 5;

--dump fulltime5;

--describe fulltime;

--fulltime: {casestatus: chararray,jobtitle: chararray,position: chararray,wage: double,year: chararray}

parttime = filter csfilter by LOWER(position) == 'n';

--parttime5 = limit parttime 5;

--dump parttime5;

--describe parttime;

--parttime: {casestatus: chararray,jobtitle: chararray,position: chararray,wage: double,year: chararray}

fullbyboth = group fulltime by (year,jobtitle);

--fullbyboth5 = limit fullbyboth 5;

--dump fullbyboth5;

--describe fullbyboth;

--fullbyboth: {group: (year: chararray,jobtitle: chararray),fulltime: {(casestatus: chararray,jobtitle: chararray,position: chararray,wage: 
--double,year: chararray)}}

fullbysum = foreach fullbyboth generate FLATTEN(group) as (year,jobtitle), fulltime.casestatus, fulltime.position, SUM(fulltime.wage) as sum, COUNT(fulltime.wage) as count;

--fullbysum10 = limit fullbysum 10;

--dump fullbysum10;

--describe fullbysum;

--fullbysum: {year: chararray,jobtitle: chararray,sum: double,count: long}

fullbyavg = foreach fullbysum generate $0, $1, ROUND_TO((DOUBLE)($4 / $5),2) as average;

yearavg = filter fullbyavg by $0 == '2011';

byorder = order yearavg by $2 desc;

byorder10 = limit byorder 10;

dump byorder10;

describe byorder;

--byorder: {year: chararray,jobtitle: chararray,{(casestatus: chararray)},{(position: chararray)},sum: double,count: long}

--byorder: {year: chararray,jobtitle: chararray,{(casestatus: chararray)},{(position: chararray)},double}

--byorder: {year: chararray,jobtitle: chararray,{(casestatus: chararray)},{(position: chararray)},double}

--byorder: {year: chararray,jobtitle: chararray,average: double}














