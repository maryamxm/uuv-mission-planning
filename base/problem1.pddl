(define (problem windfarm-mission-1)
    (:domain windfarm)

    ; -------------------------------
    ; objects in the given problem
    ; -------------------------------

    (:objects
        uuv1 - uuvs
        ship1 - ships
        WP2 - locations
        WP1 - locations
        WP3 - locations
        WP4 - locations
        image - data 
        sonarScan - data 
    )

    ; -------------------------------
    ; initial world states
    ; -------------------------------

    (:init
        (uuv uuv1) ;initialising a uuv
        (ship ship1) ;initializing a ship
        (on_ship uuv1 ship1) ;uuv1 is on ship1

        ;path connections: path from the first given location and the second
        (path WP1 WP2) 
        (path WP2 WP1)
        (path WP2 WP3)
        (path WP3 WP4)
        (path WP4 WP3)
        (path WP4 WP1)

        ;location of where the data should be collected
        (location image WP3)
        (location sonarScan WP4)
        (noData uuv1) ;uuv1 carries no initial data
    )
    
    ; -------------------------------
    ; goals to be achieved
    ; -------------------------------

    (:goal
       (and 
          (collected ship1 image) ;image should be transmitted to ship1
          (collected ship1 sonarScan) ;sonar scan should be transmitted to ship1
          (not(inAction uuv1))
        )
    )
) 