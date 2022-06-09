const axios = require("axios");

exports.handler = async (event) => {
     let statusvalue=event.Records[0].dynamodb.NewImage.STATUS;
     console.log("statusvalue",statusvalue)
     const realvalue=statusvalue[Object.keys(statusvalue)[0]];

     if(realvalue==1){
     try{ 
         const result=await axios.post("https://discordapp.com/api/webhooks/978951827548672000/KC5baNu9YVeRX3ITMhZVscLtpskqS7buLIMRPjEX0LLfoz9R-XC6fW16HvI3dclwib0n",{
        "content": "출발했습니다"});
     }
    catch(err){ 
      console.log("fail")
    }
     }
     else if(realvalue==2){
        try{
         const result=await axios.post("https://discordapp.com/api/webhooks/978951827548672000/KC5baNu9YVeRX3ITMhZVscLtpskqS7buLIMRPjEX0LLfoz9R-XC6fW16HvI3dclwib0n",{
        "content": "도착했습니다"});
           }
    catch(err){
      console.log("fail")
    }
         
     }
 };