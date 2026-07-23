/******************************************************************************/
/* @COPYRIGHT@                                                                */
/* Project: Proalpha                                                          */
/*                                                                            */
/* Name   : XSCPastSvc:prpoInstance:GetClass().cls                                                    */
/* Product: X - Individualanpassungen extern                                  */
/* Module : STAMM - Übergreifende Stammdaten                                  */
/*                                                                            */
/* Created: 9.5.0 as of 02.06.2026/thongdi_p                                  */
/* Current: @PAVERSION@ as of @PADATE@/@PALASTAUTHOR@                         */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* DESCRIPTION                                                                */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/* Class for Test Class                                                       */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* HISTORY                                                                    */
/*----------------------------------------------------------------------------*/
/* @FILEHISTORY@                                                              */
/******************************************************************************/

&GLOBAL-DEFINE pa-Autor            thongdi_p
&GLOBAL-DEFINE pa-Version          @PAVERSION@
&GLOBAL-DEFINE pa-Datum            @PADATE@
&GLOBAL-DEFINE pa-Letzter          @PALASTAUTHOR@

&GLOBAL-DEFINE pa-GenVersion       OEA
&GLOBAL-DEFINE pa-ProgrammTyp      Class
&GLOBAL-DEFINE pa-Template         paooablclass.clsjet
&GLOBAL-DEFINE pa-TemplateVersion  1.00
&GLOBAL-DEFINE pa-XBasisName       XSCPastSvc_cls
&GLOBAL-DEFINE pa-NameSpace        1.00

&GLOBAL-DEFINE pa-Package          x.stamm.cls
&GLOBAL-DEFINE pa-Class            XSCPastSvc

/* TODO: Remove this comment and the include below unless you need to reference
         compiler constants in your class. Activate the definition file only if
         necessary to avoid increased compile times.
{basis/incl/b__alp00.cdf}
*/

using x.stamm.cls.XSCPastSvc.
using adm.method.cls.DMISingletonFrw.

class x.stamm.cls.XSCPastSvc
  use-widget-pool
  implements DMISingletonFrw:
  
  define public static property prpoInstance as XSCPastSvc no-undo
  get:
    {adm/method/incl/dm_sin02.if}
  end get.
  protected set.
  
  /*  ------------------------------------------------*/
  /*    1. cGetPart                                   */
  /*  - without parameter                             */
  /*  - return the S_Artikel.Artikel of first part    */
  /*  ------------------------------------------------*/
 
  method public character cGetPart
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Get the first part (Artikel) from S_Artikel table                      */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* <none>                                                                 */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    define variable cArtikel as character no-undo.
    
    find first S_Artikel
      where S_Artikel.firma = pACConnectionSvc:prpcCompany
      no-lock no-error.
      
    if available S_Artikel then 
    do:
      cArtikel = S_Artikel.Artikel.
    end.
    
    else
    do:
      cArtikel = 'Not found Info':U.
    end.
    
    return cArtikel.
      
  end method. /* cGetPart */
  
  /*  ---------------------------------------------------------  */
  /*  2. cGetPart                                                */
  /*  - 1 parameter as S_Artikel.S_Artikel_Obj                   */
  /*  - return the S_Artikel.Artikel from S_Artikel.S_Artikel_Obj*/
  /*  ---------------------------------------------------------  */
  
  method public character cGetPart
    (pcS_Artikel_Obj like S_Artikel.S_Artikel_Obj):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Get the part number (Artikel) using its Object ID (S_Artikel_Obj)      */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* pcS_Artikel_Obj                                                        */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    define variable cResultObj as character no-undo.
    
    find S_Artikel  
      where S_Artikel.S_Artikel_Obj = pcS_Artikel_Obj 
      no-lock no-error.
      
    if available S_Artikel then 
    do:
      cResultObj = S_Artikel.Artikel.
    end.
    
    else
    do:
      cResultObj = 'Not found Info':U.
    end.
    
    return cResultObj.  
      
  end method. /* cGetPart */
  
  /*  ---------------------------  */
  /*  3. getPartWithType           */
  /*  - 2 output parameter         */
  /*  - get first part             */
  /*  - output S_Artikel.Artikel   */
  /*  - output S_Artikel.ArtikelArt*/
  /*  ---------------------------  */

  method public void getPartWithType
    ( output opcPart like S_Artikel.Artikel,
      output opcType like S_Artikel.ArtikelArt):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Get Artikel and ArtikelArt                                             */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* opcPart                                                                */
    /* opcType                                                                */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
         
    find first S_Artikel
      where S_Artikel.Firma = pACConnectionSvc:prpcCompany  
      no-lock no-error.
      
    if available S_Artikel then 
    do:
      assign
        opcPart = S_Artikel.Artikel
        opcType = S_Artikel.ArtikelArt
        .
    end.
  
  end method.

  /*  4. getPartWithType             */
  /*- 1 input parameter S_Artikel_Obj*/
  /*- 2 output parameter             */
  /*- get part from S_Artikel_Obj    */
  /*- output S_Artikel.Artikel       */
  /*- output S_Artikel.ArtikelArt    */


  method public void getPartWithType
    ( input  pcObj   like S_Artikel.S_Artikel_Obj,
      output opcPart like S_Artikel.Artikel,
      output opcType like S_Artikel.ArtikelArt):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Get Artikel and ArtikelArt using S_Artikel.S_Artikel_Obj               */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* pcObj                                                                  */
    /* opcPart                                                                */
    /* opcType                                                                */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
   find S_Artikel  
     where S_Artikel.S_Artikel_Obj = pcObj 
     no-lock no-error.
     
   if available S_Artikel then 
    do:
      assign
        opcPart = S_Artikel.Artikel
        opcType = S_Artikel.ArtikelArt
        .
    end.
         
  end method.

  /*5. getPartDescription                   */
  /*- 1 input parameter buffer S_Artikel    */
  /*- 2 output parameter                    */
  /*- get S_ArtikelSpr from buffer parameter*/
  /*- output S_Artikel.Artikel              */
  /*- output S_ArtikelSpr.Bezeichnung[1]    */
  
  method public void getPartDescription
    ( buffer bS_Artikel for  S_Artikel,
      output opcPart    like S_Artikel.Artikel,
      output opcDescrip as character ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Get description from S_ArtikelSpr based on the passed S_Artikel buffer */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* <none>                                                                 */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    assign
      opcPart     = '':U
      opcDescrip  = '':U
      .
    
    if available bS_Artikel then
    do:
      opcPart = bS_Artikel.Artikel.
      
      find first S_ArtikelSpr 
        where S_ArtikelSpr.Firma   = pACConnectionSvc:prpcCompany
          and S_ArtikelSpr.Artikel = bS_Artikel.Artikel
        no-lock no-error.
        
      if available S_ArtikelSpr then 
      do:
        opcDescrip = S_ArtikelSpr.Bezeichnung[1].
      end. /* if available S_ArtikelSpr */   
    end. /* if available bS_Artikel */ 
 
  end method.
  
  /*6. fillTTPartStartWith3              */
  /*- 1 temp-table parameter             */
  /*- fill all parts that begins with '3'*/
  
  define temp-table ttPart no-undo
    field Artikel    like S_Artikel.Artikel
    field ArtikelArt like S_Artikel.ArtikelArt
    .
    
  define variable iCount as integer init 0 no-undo.
    
  method public void fillTTPartStartWith3
    ( input-output table ttPart ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Fill the passed temp-table with parts that their ID begins with '3'    */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* ttPart                                                                 */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
   
    for each S_Artikel 
      where S_Artikel.Firma = pACConnectionSvc:prpcCompany 
        and S_Artikel.Artikel begins '3' 
      no-lock:
       
      create ttPart.
     
      assign
        ttPart.Artikel    = S_Artikel.Artikel
        ttPart.ArtikelArt = S_Artikel.ArtikelArt
        .  
    end.
   
  end method.

  /*7. cGetDefaultPart               */
  /*- call method cGetPart on point 1*/

  method public character cGetDefaultPart
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Call the parameterless cGetPart method to get the default first part   */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* <none>                                                                 */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    define variable cDefault as character no-undo.
    
    cDefault = this-object:cGetPart().
    
    return cDefault.
    
  end method. 
 
end class.