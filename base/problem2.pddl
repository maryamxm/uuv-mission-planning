(define (problem windfarm-mission-2)
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
        WP5 - locations
        image - data 
        sonarScan - data
        sample - samples
    )

    ; -------------------------------
    ; initial world states
    ; -------------------------------

    (:init
        ;ships and uuvs information
        (uuv uuv1) ;initialising a uuv
        (ship ship1) ;initialising a ship
        (on_ship uuv1 ship1) ;uuv1 is on ship1

        ;path connections: path from the first given location and the second
        (path WP1 WP2)
        (path WP2 WP3)
        (path WP3 WP5)
        (path WP5 WP1)
        (path WP1 WP4)
        (path WP4 WP3)

        ;location of where the data and samples should be collected
        (location image WP5)
        (location sonarScan WP3)
        (location sample WP1)

        ;uuv and ship initial inventory status
        (noData uuv1)
        (noSample uuv1)
        (noSample ship1)
    )

    ; -------------------------------
    ; goals to be achieved
    ; -------------------------------

    (:goal
        (and
            (collected ship1 image) ;image should be transmitted to ship1
            (collected ship1 sonarScan) ;sonar scan should be transmitted to ship1
            (carryingSample ship1 sample) ;sample should be stored in ship1
        )
    )
)