//
//  JetSpec.swift
//  CatchEmAll
//
//  Created by Michael Dippery on 8/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Quick
import Nimble
@testable import CatchEmAll

class JetSpec: QuickSpec {
    override func spec() {
        describe("Jet") {
            var plane = Plane(name: "SR-71", weight: 170000.0, maxSpeed: 2531.99, maxAltitude: 100000.0)

            beforeEach {
                plane = Plane(name: "SR-71", weight: 170000.0, maxSpeed: 2531.99, maxAltitude: 100000.0)
            }

            describe("initializers") {
                it("should set the properties") {
                    expect(plane.name).to(equal("SR-71"))
                    expect(plane.weight).to(beCloseTo(170000.0))
                    expect(plane.maxSpeed).to(beCloseTo(2531.99))
                    expect(plane.speed).to(beCloseTo(0.0))
                    expect(plane.heading).to(beCloseTo(0.0))
                    expect(plane.maxAltitude).to(beCloseTo(100000.0))
                    expect(plane.altitude).to(beCloseTo(0.0))
                    expect(plane.inFlight).to(beFalse())
                }
            }

            describe("takeOff") {
                it("should increase the plane's speed and altitude if it is not in flight") {
                    plane.takeOff()
                    expect(plane.altitude).to(beCloseTo(plane.maxAltitude / 10.0))
                    expect(plane.speed).to(beCloseTo(plane.maxSpeed / 10.0))
                    expect(plane.inFlight).to(beTrue())
                }

                it("should not do anything if the plane is in flight") {
                    plane.speed = plane.maxSpeed
                    plane.altitude = 30000.0
                    plane.takeOff()
                    expect(plane.altitude).to(beCloseTo(30000.0))
                    expect(plane.speed).to(beCloseTo(plane.maxSpeed))
                    expect(plane.inFlight).to(beTrue())
                }
            }

            describe("land") {
                it("should change the altitude and speed to 0") {
                    plane.speed = plane.maxSpeed
                    plane.altitude = 30000.0
                    plane.land()
                    expect(plane.altitude).to(beCloseTo(0.0))
                    expect(plane.speed).to(beCloseTo(0.0))
                    expect(plane.inFlight).to(beFalse())
                }

                it("should land even if the plane is on the ground") {
                    plane.land()
                    expect(plane.altitude).to(beCloseTo(0.0))
                    expect(plane.speed).to(beCloseTo(0.0))
                    expect(plane.inFlight).to(beFalse())
                }
            }

            describe("climb") {
                it("should increase the plane's altitude but decrease the speed by 1/5") {
                    plane.speed = 320.0
                    plane.altitude = 20000.0
                    plane.climb()
                    expect(plane.altitude).to(beCloseTo(20000.0 + plane.maxAltitude / 5.0))
                    expect(plane.speed).to(beCloseTo(320.0 - plane.maxSpeed * 0.1))
                    expect(plane.inFlight).to(beTrue())
                }

                it("should not increase the plane's altitude beyond its maximum altitude") {
                    plane.speed = 320.0
                    plane.altitude = plane.maxAltitude * 0.95
                    plane.climb()
                    expect(plane.altitude).to(beCloseTo(plane.maxAltitude))
                    expect(plane.speed).to(beCloseTo(320.0 - plane.maxSpeed * 0.1))
                    expect(plane.inFlight).to(beTrue())
                }

                it("should not change anything if the plane is not in flight") {
                    plane.climb()
                    expect(plane.altitude).to(beCloseTo(0.0))
                    expect(plane.speed).to(beCloseTo(0.0))
                    expect(plane.inFlight).to(beFalse())
                }
            }

            describe("dive") {
                it("should decrease the plane's altitude but increase its speed") {
                    plane.speed = 320.0
                    plane.altitude = 30000.0
                    plane.dive()
                    expect(plane.altitude).to(beCloseTo(30000.0 - plane.maxAltitude / 5.0))
                    expect(plane.speed).to(beCloseTo(320.0 + plane.maxSpeed * 0.1))
                    expect(plane.inFlight).to(beTrue())
                }

                it("should not decrease the plane's altitude below 0") {
                    plane.speed = 320.0
                    plane.altitude = 10.0
                    plane.dive()
                    expect(plane.altitude).to(beCloseTo(0.0))
                    expect(plane.speed).to(beCloseTo(320.0 + plane.maxSpeed * 0.1))
                    expect(plane.inFlight).to(beFalse())
                }

                it("should not do anything if the plane is on the ground") {
                    plane.dive()
                    expect(plane.altitude).to(beCloseTo(0.0))
                    expect(plane.speed).to(beCloseTo(0.0))
                    expect(plane.inFlight).to(beFalse())
                }
            }

            describe("bankRight") {
                it("turns the vehicle right by 45 degrees and cuts the speed by 1/10th") {
                    plane.speed = 320.0
                    plane.altitude = 30000.0
                    plane.bankRight()
                    expect(plane.speed).to(beCloseTo(320.0 * 0.9))
                    expect(plane.heading).to(beCloseTo(45.0))
                    expect(plane.inFlight).to(beTrue())
                }

                it("does nothing if the plane is not in flight") {
                    plane.bankRight()
                    expect(plane.speed).to(beCloseTo(0.0))
                    expect(plane.heading).to(beCloseTo(0.0))
                    expect(plane.inFlight).to(beFalse())
                }

                it("cannot turn past 360 degrees") {
                    plane.speed = 320.0
                    plane.altitude = 30000.0
                    plane.heading = 355.0
                    plane.bankRight()
                    expect(plane.speed).to(beCloseTo(320.0 * 0.9))
                    expect(plane.heading).to(beCloseTo(40.0))
                    expect(plane.inFlight).to(beTrue())
                }

                it("should do nothing if the plane is not in flight") {
                    plane.bankRight()
                    expect(plane.speed).to(beCloseTo(0.0))
                    expect(plane.heading).to(beCloseTo(0.0))
                    expect(plane.inFlight).to(beFalse())
                }
            }

            describe("bankLeft") {
                it("turns the vehicle right by 45 degrees and cuts the speed by 1/10th") {
                    plane.speed = 320.0
                    plane.altitude = 30000.0
                    plane.bankLeft()
                    expect(plane.speed).to(beCloseTo(320.0 * 0.9))
                    expect(plane.heading).to(beCloseTo(315.0))
                    expect(plane.inFlight).to(beTrue())
                }

                it("does nothing if the plane is not in flight") {
                    plane.bankLeft()
                    expect(plane.speed).to(beCloseTo(0.0))
                    expect(plane.heading).to(beCloseTo(0.0))
                    expect(plane.inFlight).to(beFalse())
                }

                it("cannot turn past 360 degrees") {
                    plane.speed = 320.0
                    plane.altitude = 30000.0
                    plane.heading = 10.0
                    plane.bankLeft()
                    expect(plane.speed).to(beCloseTo(320.0 * 0.9))
                    expect(plane.heading).to(beCloseTo(325.0))
                    expect(plane.inFlight).to(beTrue())
                }

                it("should do nothing if the plane is not in flight") {
                    plane.bankLeft()
                    expect(plane.speed).to(beCloseTo(0.0))
                    expect(plane.heading).to(beCloseTo(0.0))
                    expect(plane.inFlight).to(beFalse())
                }
            }

            describe("afterburner") {
                it("should set the speed to twice the jet's max speed") {
                    plane.speed = plane.maxSpeed
                    plane.altitude = 85000.0
                    plane.afterburner()
                    expect(plane.speed).to(beCloseTo(plane.maxSpeed * 2.0))
                    expect(plane.altitude).to(beCloseTo(85000.0))
                    expect(plane.inFlight).to(beTrue())
                }

                it("should do nothing if the plane is not already at max speed") {
                    plane.speed = 1500.0
                    plane.altitude = 85000.0
                    plane.afterburner()
                    expect(plane.speed).to(beCloseTo(1500.0))
                    expect(plane.altitude).to(beCloseTo(85000.0))
                    expect(plane.inFlight).to(beTrue())
                }

                it("should do nothing if the plane is not in flight") {
                    plane.afterburner()
                    expect(plane.speed).to(beCloseTo(0.0))
                    expect(plane.altitude).to(beCloseTo(0.0))
                    expect(plane.inFlight).to(beFalse())
                }
            }
        }
    }
}
