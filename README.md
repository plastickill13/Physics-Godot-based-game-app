# Midnight Driver
A Physics-based driving game made with Godot 4.4. This is a simple game which highlights how physics affect movement, specifically on how it works with objects and vehicles. Collaborated with a creative team of 4 to deliver the project for uni. 

Inspired by [easy delivery co.](https://store.steampowered.com/app/3293010/Easy_Delivery_Co/)


## Screenshots

<img width="1919" height="1079" alt="Screenshot 2026-08-31 172413" src="https://github.com/user-attachments/assets/139f0614-902e-4dd0-b65b-3e3d5a3b40ad" />


<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/59391aae-fc3b-45a9-a100-df2d39d12102" />


<img width="1919" height="1079" alt="image" src="https://github.com/user-attachments/assets/04ecc886-236a-4c3c-9958-26a5c5c9b30c" />

## In-Game Features

- Car Stereo
- Simple Delivery System
- Cool car manuevering system 😎


## Core Gameplay Mechanics

* **Physics Payload:** Cargo items are simulated using `RigidBody3D` nodes. Packages feature varying mass, friction, and elasticity properties. Loading these items dynamically alters the vehicle's center of mass and handling characteristics.
* **Delivery Loop:** Players accept transport manifests from NPCs, receive physical cargo into the truck bed via a loading chute, and navigate to designated `Area3D` drop-off zones to earn currency.
* **Dynamic Penalties:** Reckless driving, sharp turns, or high-speed impacts result in cargo ejection or vehicle rollovers due to inertia. Players can manually recover lost cargo or incur a monetary penalty to respawn items.
* **Progression System:** Currency earned from successful deliveries can be allocated toward vehicle upgrades. These upgrades directly modify physics parameters, such as increasing engine force or stiffening suspension springs.

## Physics Principles Demonstrated

* **First Law (Inertia):** Heavy cargo requires greater braking distance. High-stacked cargo shifts the center of mass upward, increasing the likelihood of a rollover during sharp turns as the payload resists directional changes.
* **Second Law ($F = ma$):** The vehicle's acceleration scales inversely with the total mass of the loaded cargo. 
* **Third Law (Action and Reaction):** Navigating uneven terrain exerts upward force on the vehicle's suspension, transferring kinetic energy to the unsecured cargo and requiring velocity management to prevent ejection.

## Technical Implementation

* **Engine:** Godot 4.x
* **Language:** GDScript
* **Vehicle Controller:** Utilizes Godot's built-in `VehicleBody3D` and `VehicleWheel3D` nodes for calculated suspension and tire friction.
* **Cargo Detection:** Implements a composite collision shape for the truck bed, paired with an `Area3D` node to monitor and validate the active payload array.

## Installation and Setup

1.  Clone the repository to your local machine.
2.  Open the Godot 4 Project Manager.
3.  Select "Import" and navigate to the `project.godot` file within the cloned directory.
4.  Open the project and run the `Main.tscn` (or equivalent level scene) to begin the simulation.
