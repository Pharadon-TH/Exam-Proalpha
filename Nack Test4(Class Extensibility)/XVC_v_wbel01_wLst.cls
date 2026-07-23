/******************************************************************************/
/* @COPYRIGHT@                                                                */
/* Project: Proalpha                                                          */
/*                                                                            */
/* Name   : XVC_v_wbel01_wLst.cls                                             */
/* Product: X - Individualanpassungen extern                                  */
/* Module : VERT - Vertrieb                                                   */
/*                                                                            */
/* Created: 9.5.0 as of 16.06.2026/thongdi_p                                  */
/* Current: @PAVERSION@ as of @PADATE@/@PALASTAUTHOR@                         */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* DESCRIPTION                                                                */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/* Trigger for Rechnung                                                       */
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
&GLOBAL-DEFINE pa-XBasisName       XVC_v_wbel01_wLst_cls
&GLOBAL-DEFINE pa-NameSpace        1.00

&GLOBAL-DEFINE pa-Package          x.vert.cls
&GLOBAL-DEFINE pa-Class            XVC_v_wbel01_wLst

/* TODO: Remove this comment and the include below unless you need to reference
         compiler constants in your class. Activate the definition file only if
         necessary to avoid increased compile times.
{basis/incl/b__alp00.cdf}
*/

using x.vert.cls.XVC_v_wbel01_wLst.
using adm.method.cls.DMITriggerProcedureLst.
using adm.method.cls.DMCTriggerProcedureSvo.
using adm.method.cls.DMITriggerProcedureLst.

class x.vert.cls.XVC_v_wbel01_wLst
  use-widget-pool
  implements DMITriggerProcedureLst:
  
  constructor protected XVC_v_wbel01_wLst
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Protected constructor to enforce DI framework usage                    */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    super().
    
  end constructor.
  
  
  method public static XVC_v_wbel01_wLst create
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Factory method to create instance via DI framework                     */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    {adm/method/incl/dm_fac01.if}
    
  end method.
  
  
  method public void subscribeTriggerEvents
    ( poTriggerProcedure as DMCTriggerProcedureSvo ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Subscription method for trigger events.                                */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poTriggerProcedure      Trigger procedure instance.                    */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    poTriggerProcedure:subscribeOnTrigger-PostProcessing(this-object, 'OnTrigger-PostProcessing':U).
    
  end method.


  method public void OnTrigger-PostProcessing
    ( phV_BelegKopf     as handle,
      phV_BelegKopf_Old as handle ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* OnTrigger-PostProcessing                                               */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* phV_BelegPos                                                           */
    /* phV_BelegPos_Old                                                       */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    define buffer bS_Kunde          for S_Kunde.
    
    define variable cTempRouteID    as character no-undo.
    define variable cBelegArt       as character no-undo.
    define variable cKunde          as character no-undo.
    define variable cInvoiceObj     as character no-undo.
    
    
    if phV_BelegKopf::BelegArt = 'R':U then
    do:
      
      find first bS_Kunde
        where bS_Kunde.Firma = {firma/s_kunde.fir pACConnectionSvc:prpcCompany}
          and bS_Kunde.Kunde = phV_BelegKopf::Kunde
        no-lock no-error.
            
      if available bS_Kunde then
      do:
            
        cTempRouteID = basis.base.cls.BMCAddDataSvc:cValue 
                          (bS_Kunde.S_Kunde_Obj, 
                           'xVF_Leitweg_ID':U).
                                                   
        if cTempRouteID <> '' then
        do:
          vert.fakt.cls.VFCXInvoiceSvc:prpoInstance:saveRouteID
            (/* pcRouteID    */ cTempRouteID,
             /* pcInvoiceObj */ phV_BelegKopf::V_BelegKopf_Obj).
        end.
            
      end. /* if available bS_Kunde */       
        
    end. /* if phV_BelegKopf::BelegArt = 'R':U */
                     
    
  end method.
   
  
  
end class.