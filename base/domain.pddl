(define (domain windfarm)
    (:requirements :strips :typing)

    ; -------------------------------
    ; Types
    ; -------------------------------
    
    (:types
        uuvs
        ships
        samples
        data ;data type will both include images and sonar scans
        locations ;includes the waypionts given in problems 
    )

    ; -------------------------------
    ; Predicates
    ; -------------------------------

    (:predicates
        (uuv ?x - uuvs) ;for using multiple uuv
        (ship ?s - ships) ;for using multiple ships
        (carryingSample ?x - (either uuvs ships) ?y - samples) ;uuv or ship x is carrying sample y 
        (collected ?x - (either uuvs ships) ?d - data) ;ship or uuv x has collected data d  
        (location ?m - (either uuvs ships samples data) ?l - locations) ;m is at location l 
        (path ?l1 - locations ?l2 - locations) ;path from location l1 to l2
        (on_ship ?x - uuvs ?s - ships) ;uuv x is on ship s
        (noData ?x - uuvs) ;uuv x has collected no data in its data inventory
        (noSample ?m - (either uuvs ships))  ;uuv or ship m has no sample collected
        (inAction ?x - uuvs) ;the uuv is in action and has not finished all the goals once in the sea
    )

    ; -------------------------------
    ; Actions
    ; -------------------------------
   
    ;deploys a given uuv from a given ship at a certain location
    (:action deploy
        :parameters 
           (?x - uuvs ?s - ships ?l - locations)
        :precondition (and
           (ship ?s)
           (uuv ?x)
           (on_ship ?x ?s)
        )
        :effect (and
           (not (on_ship ?x ?s))
           (location ?s ?l)
           (location ?x ?l)
           (inAction  ?x) 
        )
    )
    
    ;moves a given uuv to a given location from its current location
    (:action moving
        :parameters 
           (?x - uuvs ?l1 - locations ?l2 - locations)
        :precondition (and
           (uuv ?x)
           (location ?x ?l1)
           (path ?l1 ?l2)
           (inAction  ?x)
        )
        :effect (and
           (not (location ?x ?l1)) 
           (location ?x ?l2)
        )
    )
    
    ;the given uuv collects data including images and sonar scans from a certain location
    ;given that the uuv can store only one data at a time
    (:action collect_data
        :parameters 
           (?x - uuvs ?l - locations ?d - data)
        :precondition (and
           (uuv ?x)
           (location ?x ?l)
           (location ?d ?l)
           (noData ?x)
           (inAction  ?x)
        )
        :effect (and
           (not (noData ?x))
           (collected ?x ?d)
        )
    )
    
    ;the uuv transmits data to a given ship given that the uuv has collected a type of data
    (:action transmit_data
        :parameters 
           (?x - uuvs ?s - ships ?d - data)
        :precondition (and
           (uuv ?x)
           (ship ?s)
           (collected ?x ?d)
           (not (noData ?x))
           (inAction  ?x)
        )
        :effect (and
           (noData ?x)
           (collected ?s ?d)
        )
    )
    
    ;the given uuv collects a sample at a specific location
    ;given that the uuv can only hold one sample at the time
    (:action collect_sample
        :parameters 
           (?x - uuvs ?y - samples ?l - locations)
        :precondition (and
           (uuv ?x)
           (location ?x ?l)
           (location ?y ?l)
           (noSample ?x)
           (inAction  ?x)
        )
        :effect (and
           (carryingSample ?x ?y)
           (not (noSample ?x))
           )
    )
    
    ;the uuv delivers the sample its carrying to the given ship at the deployment location
    ;given that each ship can only collect one sample
    (:action deliver_sample
        :parameters 
           (?x - uuvs ?y - samples ?ls - locations ?s - ships)
        :precondition (and
           (uuv ?x)
           (ship ?s)
           (location ?x ?ls)
           (location ?s ?ls)
           (noSample ?s)
           (carryingSample ?x ?y)
           (inAction ?x)
        )
        :effect (and
           (not (carryingSample ?x ?y))
           (not (noSample ?s))
           (carryingSample ?s ?y)
           (not (inAction ?x))
        )
    )
   
   (:action back_to_ship
        :parameters 
           (?x - uuvs ?s - ships ?l - locations)
        :precondition (and
           (uuv ?x)
           (ship ?s)
           (location ?x ?l)
           (location ?s ?l)
           (inAction ?x)
        )
        :effect (and
           (not(inAction ?x))
           )
    )

)