select p1.value, p2.value 
from prime as p1
inner join prime as p2 on p1.value = p2.value - 2
;
