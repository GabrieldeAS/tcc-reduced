(define (problem MultiActor)
(:domain BlockWorld-Mecatronics)
(:objects 
	place_0_0  place_0_1  place_0_2  place_0_3  place_0_4  place_1_0  place_1_1  place_1_2  place_1_3  place_1_4  place_2_0  place_2_1  place_2_2  place_2_3  place_2_4  place_3_0  place_3_1  place_3_2  place_3_3  place_3_4 - place

 	arm0 	arm1  - arm

 	blockD 	blockC 	blockB 	blockA  - block
)
(:init 
	(adjacentup place_0_0 place_0_1) 
	(adjacentdown place_0_1 place_0_0)
	(adjacentup place_0_1 place_0_2)
	(adjacentdown place_0_2 place_0_1)
	(adjacentup place_0_2 place_0_3)
	(adjacentdown place_0_3 place_0_2)
	(adjacentup place_0_3 place_0_4)
	(adjacentdown place_0_4 place_0_3) 
	(adjacentup place_1_0 place_1_1) 
	(adjacentdown place_1_1 place_1_0)
	(adjacentup place_1_1 place_1_2)
	(adjacentdown place_1_2 place_1_1)
	(adjacentup place_1_2 place_1_3)
	(adjacentdown place_1_3 place_1_2)
	(adjacentup place_1_3 place_1_4)
	(adjacentdown place_1_4 place_1_3)
	(adjacentup place_2_0 place_2_1) 
	(adjacentdown place_2_1 place_2_0)
	(adjacentup place_2_1 place_2_2)
	(adjacentdown place_2_2 place_2_1)
	(adjacentup place_2_2 place_2_3)
	(adjacentdown place_2_3 place_2_2)
	(adjacentup place_2_3 place_2_4)
	(adjacentdown place_2_4 place_2_3)
	(adjacentup place_3_0 place_3_1) 
	(adjacentdown place_3_1 place_3_0)
	(adjacentup place_3_1 place_3_2)
	(adjacentdown place_3_2 place_3_1)
	(adjacentup place_3_2 place_3_3)
	(adjacentdown place_3_3 place_3_2)
	(adjacentup place_3_3 place_3_4)
	(adjacentdown place_3_4 place_3_3)
	(adjacentright place_0_0 place_1_0)
	(adjacentleft place_1_0 place_0_0)
	(adjacentright place_1_0 place_2_0)
	(adjacentleft place_2_0 place_1_0)
	(adjacentright place_2_0 place_3_0)
	(adjacentleft place_3_0 place_2_0)
	(adjacentright place_0_1 place_1_1)
	(adjacentleft place_1_1 place_0_1)
	(adjacentright place_1_1 place_2_1)
	(adjacentleft place_2_1 place_1_1)
	(adjacentright place_2_1 place_3_1)
	(adjacentleft place_3_1 place_2_1)
	(adjacentright place_0_2 place_1_2)
	(adjacentleft place_1_2 place_0_2)
	(adjacentright place_1_2 place_2_2)
	(adjacentleft place_2_2 place_1_2)
	(adjacentright place_2_2 place_3_2)
	(adjacentleft place_3_2 place_2_2)
	(adjacentright place_0_3 place_1_3)
	(adjacentleft place_1_3 place_0_3)
	(adjacentright place_1_3 place_2_3)
	(adjacentleft place_2_3 place_1_3)
	(adjacentright place_2_3 place_3_3)
	(adjacentleft place_3_3 place_2_3)
	(adjacentright place_0_4 place_1_4)
	(adjacentleft place_1_4 place_0_4)
	(adjacentright place_1_4 place_2_4)
	(adjacentleft place_2_4 place_1_4)
	(adjacentright place_2_4 place_3_4)
	(adjacentleft place_3_4 place_2_4)

	(holdarm  place_1_4   arm0 ) 
	(freetopick  arm0 )
	(holdarm  place_2_4   arm1 ) 
	(freetopick  arm1 )

	(holdblock  place_2_1   blockD) 
	(holdblock  place_1_3   blockC) 
	(holdblock  place_1_2   blockB) 
	(holdblock  place_1_1   blockA) 

	(freetomoveblock place_0_1) 
	(freetomoveblock place_0_2) 
	(freetomoveblock place_0_3) 
	(freetomoveblock place_0_4) 
	(freetomoveblock place_1_4) 
	(freetomoveblock place_2_2) 
	(freetomoveblock place_2_3) 
	(freetomoveblock place_2_4) 
	(freetomoveblock place_3_1) 
	(freetomoveblock place_3_2) 
	(freetomoveblock place_3_3) 
	(freetomoveblock place_3_4) 

	(freetomove place_0_1) 
	(freetomove place_0_2) 
	(freetomove place_0_3) 
	(freetomove place_0_4) 
	(freetomove place_1_3) 
	(freetomove place_1_4) 
	(freetomove place_2_1) 
	(freetomove place_2_2) 
	(freetomove place_2_3) 
	(freetomove place_2_4) 
	(freetomove place_3_1) 
	(freetomove place_3_2) 
	(freetomove place_3_3) 
	(freetomove place_3_4) 

	(freetomovearm place_0_1) 
	(freetomovearm place_0_2) 
	(freetomovearm place_0_3) 
	(freetomovearm place_0_4) 
	(freetomovearm place_1_1) 
	(freetomovearm place_1_2) 
	(freetomovearm place_1_3) 
	(freetomovearm place_2_1) 
	(freetomovearm place_2_2) 
	(freetomovearm place_2_3) 
	(freetomovearm place_3_1) 
	(freetomovearm place_3_2) 
	(freetomovearm place_3_3) 
	(freetomovearm place_3_4) 

	(stackedblock  blockB  blockA) 
	(stackedblock  blockC  blockB) 
)

(:goal (and 
	(holdarm  place_3_4   arm0 ) 
	(holdarm  place_0_4   arm1 ) 

	(holdblock  place_1_2   blockD) 
	(holdblock  place_2_1   blockC) 
	(holdblock  place_1_1   blockB) 
	(holdblock  place_1_3   blockA) 
	)
)
)