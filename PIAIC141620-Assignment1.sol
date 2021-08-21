//Assignnet 1 from roll Number PIAIC141620 Batch 34 - Zeeshan Ahmad
pragma solidity 0.8.0;

contract ParentVehicle {
    
    function start() public pure returns (string memory) {
        
        return "The Vehicle has just Started";
    }
       
    function accelarate() public pure returns (string memory) {
        
        return "The Vehicle has just Accelarated";
    }
       
    function stop() public pure returns (string memory) {
        
        return "The Vehicle has just Stoped";
    }
       
    function service() public pure virtual returns (string memory) {
        
        return "The Vehicle is being serviced";
    }
    
}

contract Car is ParentVehicle {
    
        function service() override virtual public pure returns (string memory) {
        
        return "The car is being serviced";
    }
  
}
contract Truck is ParentVehicle {
    
      function service() override virtual public pure returns (string memory) {
        
        return "The Truck is being serviced";
    }
    
}
contract MotorCycle is ParentVehicle {
    
      function service() override virtual public pure returns (string memory) {
        
        return "The Motor Cycle is being serviced";
    }
    
}

contract AltoMehran is  ParentVehicle, Car {
 
 function service() override(ParentVehicle,Car) public pure returns (string memory) {
         return "Alto is serviced";
 }
 
}
contract Hino is ParentVehicle, Truck {
   function service() override(ParentVehicle,Truck) public pure returns (string memory) {
     return "Hino is serviced";
 }  
    
}
contract Yamaha is ParentVehicle, MotorCycle {
     function service() override(ParentVehicle,MotorCycle) public pure returns (string memory) {
     return "Yamaha is serviced";
 }
  
}
contract CarServiceStation  {
    function DoService(AltoMehran _car) public pure {
        
        _car.service();
         }
  
    function DoService(Hino _truck) public pure {
        
        _truck.service();
         }
    
      function DoService(Yamaha _mBike) public pure {
        
        _mBike.service();
         }
    
}