ReadME
Attenuator
The Attenuator superclass defines methods for intialising any attenuator object like spring, damper on inerter
The constructor requires the force constant, location of fixed end initial location of mobile end as well as the offset with respect to the center of mass of attached body. 

MobileNodeVel:
Returns the velocity of the mobile node. For 2-DOF model the mobile node velocity is the same as the tub C.O.M velocity. The method will just return input values. 

*Note this velocity should not be confused with attenuator velocity which refers to the linear relative velo city between the two nodes. This is essentially the axial velocity between the nodes. 