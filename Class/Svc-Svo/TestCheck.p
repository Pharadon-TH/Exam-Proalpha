
/*--------------------------------------------------- */
/*1.*/
message x.stamm.cls.XSCPastSvc:prpoInstance:cGetPart().
/*---------------------------------------------------*/


/*---------------------------------------------------*/
/*2.*/
message x.stamm.cls.XSCPastSvc:prpoInstance:cGetPart
  ( /* pcS_Artikel_Obj */ 'PA0490:pA:8acea1a7002696acdc1116b91cac3e94':U ).
  
/*---------------------------------------------------*/ 
/*3.*/
define variable cPart as character no-undo.
define variable iType as integer   no-undo.
  
x.stamm.cls.XSCPastSvc:prpoInstance:getPartWithType
  ( /* opcPart */ output cPart,
    /* opcType */ output iType).
    
message 
  cPart skip
  iType.
        
/*---------------------------------------------------*/ 
/*4.*/

define variable cPart as character no-undo.
define variable iType as integer   no-undo. 
      
x.stamm.cls.XSCPastSvc:prpoInstance:getPartWithType
  ( /* pcObj   */ 'PA0490:pA:8acea1a7002696acdc1116b973c91e95':U,
    /* opcPart */ output cPart,
    /* opcType */ output iType ).
    
message 
  cPart skip
  iType
  .

/*---------------------------------------------------*/ 
/*5.*/
        
define variable cPart as character no-undo.
define variable cDesc as character no-undo.

find first S_Artikel
   where S_Artikel.S_Artikel_Obj = 'PA0490:pA:8acea1a7002696acdc1116b973c91e95':U
   no-lock no-error.
      
x.stamm.cls.XSCPastSvc:prpoInstance:getPartDescription
  ( /* bS_Artikel */ buffer S_Artikel,
    /* opcPart    */ output cPart,
    /* opcDescrip */ output cDesc ).
        
message 
  cPart skip
  cDesc
  .
        
        
/*---------------------------------------------------*/ 
/*6.*/

define temp-table ttPart no-undo
    field Artikel    like S_Artikel.Artikel
    field ArtikelArt like S_Artikel.ArtikelArt
    .

 

/*---------------------------------------------------*/ 
/*7.*/ 

message x.stamm.cls.XSCPastSvc:prpoInstance:cGetDefaultPart().


/***************************/
/*Class Practice #2*/

/*2.1*/

define variable oPart as class x.stamm.cls.XSCPracticeSvo no-undo.
  
oPart = x.stamm.cls.XSCPracticeSvo:create
  ( /* pcS_Artikel_Obj */ 'PA0490:pA:8acea1a7002696acdc1116b973c91e95':U ).

if valid-object(oPart) then 
do:
  message 
    oPart:prpcPart skip
    oPart:prpiPartType skip
    oPart:prpcPartDescription
    .     
  delete object oPart no-error.
end.


/*---------------------------------------------------*/
/*Implement the following methods:*/

/*2.2*/
define variable oPartCus as class x.stamm.cls.XSCPracticeSvo no-undo.

define stream stExportCus.

output stream stExportCus to 'C:\Users\thongdi_p\Downloads\Task2_Customer.csv'.
put stream stExportCus unformatted 'Part;CustomerNumber;CustomerName':U skip.

for each S_Artikel
  where S_Artikel.Firma   = {firma/sartikel.fir pACConnectionSvc:prpcCompany}
  no-lock
  on error undo, throw:
    
  oPartCus = x.stamm.cls.XSCPracticeSvo:create(S_Artikel.S_Artikel_Obj).

  if valid-object(oPartCus) then 
  do:
    
    oPartCus:exportCustomerRelation(stream stExportCus:handle).
     
    delete object oPartCus.
      
  end. /* if valid-object(oPartCus) */
  
end. /* for each S_Artikel */

output stream stExportCus close.


/*---------------------------------------------------*/
/*2.3*/

define variable oPartCusSup as class x.stamm.cls.XSCPracticeSvo no-undo.

define stream stCusSub.

output stream stCusSub to 'C:\Users\thongdi_p\Downloads\Task3_AllRelations.csv'.
put stream stCusSub unformatted 'Part;RelationType;RelationNumber;RelationName':U skip.


for each S_Artikel
  where S_Artikel.Firma   = {firma/sartikel.fir pACConnectionSvc:prpcCompany}
  no-lock
  on error undo, throw:
    
  oPartCusSup = x.stamm.cls.XSCPracticeSvo:create(S_Artikel.S_Artikel_Obj).

  if valid-object(oPartCusSup) then 
  do:
    
    oPartCusSup:exportAllRelation(stream stCusSub:handle).
    
    delete object oPartCusSup.
    
  end. /* if valid-object(oPartCusSup) */
  
end. /* for each S_Artikel */

output stream stCusSub close.
