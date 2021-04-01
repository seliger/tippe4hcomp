---
title: 'Rebuilding a Robot'
subtitle: 'Moving a robot from Arduino to Raspberry Pi'
summary: A brief overview of an adventure to switch a robot to Rasperry Pi.
authors:
- seliger
tags:
- Blog
categories:
- robotics
- hardware
- programming
date: "2020-03-31T00:20:00Z"
lastmod: "2020-03-31T00:20:00Z"
featured: false
draft: false

projects: []
---

## Intro

A couple of Christmases ago, I received an [ELEGOO UNO R3 Project Smart Robot Car](https://www.elegoo.com/collections/robot-kits/products/elegoo-smart-robot-car-kit-v-3-0-plus) from my family as a gift. I thoroughly enjoyed assembling it and playing around with it using the included remote control or the app it has for Bluetooth. While Arduino is a fairly robust platform, I wanted something that I felt more comfortable controlling. Enter: [Raspberry Pi](https://www.raspberrypi.org).

Out of the box, the Smart Robot Car is well equipped:

* Ultrasonic Sensor for detecting objects and obstructions
* Triple-sensor line following module
* Bluetooth (BLE) onboard
* Infra-red receiver and remote control
* Intelligent power pack to charge and maintain two 18650 Lithium batteries
* Android/iPhone App for controlling and using "block" language
* Pre-configured Arduino UNO with code to drive, use object detection, line following, and manual driving

Some of the things that I felt were missing:

* Ability to extend it outside the pre-fabricated boards made by ELEGOO
* Video for object/face/etc. detection
* The ability to use other software platforms, like [Python](https://www.python.org) to program the car

{{< figure src="images/robot-002.jpg" >}}

## Getting Started

### Specs

I went with a [Raspberry Pi 4b](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/), 8GB edition. **This is overkill!** It just happened to be the Pi I already had on hand. If I need to take the robot apart in the future, I might swap it for a 3, or at least a 4b with less memory. I bought it as a part of a [Starter Kit](https://www.canakit.com/raspberry-pi-4-starter-kit.html) from CanaKit. I did this because, at the time, I intended on using it as a desktop. It is running the standard [Raspberry Pi OS](https://www.raspberrypi.org/software/operating-systems/). The Wifi is enabled and Secure Shell is the primary access method (although the full desktop is still enabled).

{{< figure src="images/robot-003.jpg" >}}

### Prerequisites

I wish I could say retrofitting a Raspberry Pi on a robot previously configured for Arduino is easy, but it's not. Off the top, here are a few things I had to reconfigure or adjust:

* Bore new/different holes into the two acrylic platforms to hold the Raspberry Pi and the motor [HAT](https://www.raspberrypi.org/blog/introducing-raspberry-pi-hats/). 
* Obtain M2 head cap bolts and nuts to replace some of the larger bolts suppled with the original kit.
* The original kit provided a motor controller board attached to the lower platform. I wanted to keep that design descision, so I had to buy some 40-pin ribbon cable to ensure I could interface the motor HAT even though the Pi and other accessories remained on the upper platform.
* Purchased additional varying sizes of both male and female [JST connectors](https://en.wikipedia.org/wiki/JST_connector) and pigtails. This allowed me to reuse existing cabling and not cut/modify any of the original components.

### Purpose

To build the robot, I needed to decide what I wanted to do with it beyond what the Arduino would provide. The major piece for me was to attach a camera to do better object identification. There are many examples of leveraging [OpenCV](https://www.opencv.org) to do basic things like facial recognition. The original bot is equipped with an ultrasonic sensor, which is adequate for basic sensing, but has some limitations that can be overcome by actual vision and object detection.

The other requirement: ensure that ALL of the original components connected to the Rasperry Pi so they could be used exactly the same way as they were with the Arduino controller. This would require some extra work and ultimately building a custom HAT to support both the ultrasonic sensor and the line detection modules. The Robot Car includes a reasonably usable app for Android and iOS to control and even use block language to develop rudamentary programs. I wanted to provide enough backwards compatiblity so that the app would work.

### The Build

#### The Motor HAT

The first order of business required acquiring and testing to ensure the motors would run with the Rasperry Pi. I selected the [Adafruit DC+Stepper motor HAT](https://www.adafruit.com/product/2348). It drives up to four DC motors or two stepper motors. It also will control up to four servo motors. This HAT proved valuable as I needed a servo controller to drive the left-to-right motion of the ultrasonic sensor.

{{< figure src="images/robot-004.jpg" >}}

Before proceeding too far down the path, I connected the motor HAT to the Pi and the battery pack to determine if it would work. The video below shows that this seemingly would work.

{{< youtube id="1EHChgWsCPE" title="Testing the DC Motors" >}}

#### The Custom Sensor HAT

The second challenge was to develop a way to use the original kit sensors. Beyond the ability to use the sensors, I didn't want to cut or otherwise damange any original connectors or wires. Furthermore, the Raspberry Pi GPIO tends to deliver and expect 5 volts, whereas the Arduino sensors require 3.3 volts. This meant creating a set of voltage dividers to reduce the current being delivered to the sensors. Several different prototyping boards are available. This [breakout board](https://czh-labs.com/products/czh-labs-prototype-breakout-pcb-shield-board-kit-for-raspberry-pi-3-2-b-a-breadboard-diy) suited my purposes well.

{{< figure src="images/robot-005.jpg" >}}

I won't get into the details here, but creating [voltage dividers](https://thepihut.com/blogs/raspberry-pi-tutorials/hc-sr04-ultrasonic-range-sensor-on-the-raspberry-pi) requires the use of different resistors to draw enough current away from the components to meet their needs without frying them. I needed a voltage divider for the ultrasonic sensor, and one for each of the line detection sensors on the bottom of the car. This was a good experience for me, as I had never really soldered a real circuit board before.

{{< figure src="images/robot-006.jpg" >}}

#### The Pan and Tilt HAT

I needed a way to mount the camera. The robot car kit did not have an obvious way to do that, and I don't own a 3D printer to manufacture a custom mount. I opted for the [Waveshare Pan-Tilt HAT](https://www.waveshare.com/pan-tilt-hat.htm). This was an unexpected bonus because with it, I would be able to turn the camera and look in a multitude of directions.

{{< figure src="images/robot-007.jpg" >}}

### Building the Robot

Once I had the holes drilled, the right screws and nuts, the assembly began.

The lower platform contains the motors and the motor hat. The Arduino version had the motor controller board on the lower platform, so I used a ribbon cable to keep the Pi-equivalent motor HAT and the motor power connectors underneath.

{{< figure src="images/robot-010.jpg" >}}

On the upper platform, the Raspberry Pi is attached directly. Of course, I didn't consider the size differential between the Arduino and the Pi, so it is mounted off-center.

{{< figure src="images/robot-012.jpg" >}}

The breakout board for the ultrasonic and line detecton sensors is next.

{{< figure src="images/robot-011.jpg" >}}

The pan and tilt HAT went on last. Below is the car fully assembled, full with camera and power supply.

{{< figure src="images/robot-009.jpg" >}}

As always, it's important to stop and test things along the way. Below is a quick clip of the servo motors rotating the ultrasonic sensor and the pan and tilt arm.

{{< youtube id="hUEM056FDwA" title="Starting up the Servos" >}}

## What's Next?

* WRITING SOME ACTUAL CODE! Right now I have some basic scaffolding to propel the robot forward, view the camera output, and drive the car forward. So much more work to do.
* Add a gyroscope. I want to be able to detect the direction and directional drift of the robot while it is driving.

{{< figure src="images/robot-013.jpg" >}}

## Final Thoughts

<<<<<<< HEAD
I'm glad I did this. I learned more about the lower layers of robotics hardware beyond the VEX IQ or LEGO kits. I determined I'm pretty good at soldering, but could use some more practice. I also gained confidence in "hacking" something together from effectively nothing. It's a great little toy, and much more learning will occur with it.
=======
I'm glad I did this. I learned more about the lower layers of robotics hardware beyond the VEX IQ or LEGO kits. I determined I'm pretty good at soldering, but could use some more practice. I also gained confidence in "hacking" someting together from effectively nothing. It's a great little toy, and much more learning will occur with it.
>>>>>>> 7eeef9bac1b18ea30e7788a34ccaae60b40c0f14

Thanks for tagging along with me!
