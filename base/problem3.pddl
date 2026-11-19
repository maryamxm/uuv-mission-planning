(define (problem windfarm-mission-3)
    (:domain windfarm)

    ; -------------------------------
    ; objects in the given problem
    ; -------------------------------
    
    (:objects
        uuv1 - uuvs
        uuv2 - uuvs
        ship1 - ships
        ship2 - ships
        WP1 - locations
        WP2 - locations
        WP3 - locations
        WP4 - locations
        WP5 - locations
        WP6 - locations
        image1 - data
        image2 - data
        sonarScan1 - data 
        sonarScan2 - data
        sample1 - samples
        sample2 - samples
    )

    ; -------------------------------
    ; initial world states
    ; -------------------------------

    (:init

        ;ships and uuvs information
        (uuv uuv1) ;initializing uuv1 
        (uuv uuv2) ;initializing uuv2
        (ship ship1) ;initializing ship1
        (ship ship2) ;initializing ship2
        (not (on_ship uuv1 ship1)) ;uuv1 is not on the ship1
        (location uuv1 WP2) ;uuv1 starts already being deployed at location WP2
        (location ship1 WP2) ;ship1 is at deployment site at WP2
        (on_ship uuv2 ship2) ;uuv2 is on ship2
        (inAction uuv1) ;uuv is in action, already in the sea

        ;path connections: path from the first given location and the second
        (path WP1 WP2)
        (path WP2 WP1)
        (path WP2 WP4)
        (path WP4 WP2)
        (path WP2 WP3)
        (path WP3 WP5)
        (path WP5 WP3)
        (path WP5 WP6)
        (path WP6 WP4)

        ;location of where each data and sample should be collected
        (location image1 WP2)
        (location image2 WP3)
        (location sonarScan1 WP4)
        (location sonarScan2 WP6)
        (location sample1 WP1)
        (location sample2 WP5)

        ;uuv and ship initial inventory status
        (noData uuv1)
        (noData uuv2)
        (noSample uuv1)
        (noSample uuv2)
        (noSample ship1)
        (noSample ship2)
    )

    ; -------------------------------
    ; goals to be achieved
    ; -------------------------------

    (:goal
        (and
            (collected ship2 image2) ;ship2 has collected image2
            (collected ship1 sonarScan1) ;ship1 has collected sonar scan1
            (collected ship1 image1) ;ship1 has collected image1
            (collected ship2 sonarScan2) ;ship2 has collected sonar scan2
            (carryingSample ship2 sample2) ;ship2 has collected sample2
            (carryingSample ship1 sample1) ;ship1 has collected sample1
        )
    )
)