/******************************************************************************/
/* @COPYRIGHT@                                                                */
/* Project: Proalpha                                                          */
/*                                                                            */
/* Name   : XSC_s_wkun00_w_Lst.cls                                            */
/* Product: X - Individualanpassungen extern                                  */
/* Module : STAMM - Übergreifende Stammdaten                                  */
/*                                                                            */
/* Created: 9.5.0 as of 12.06.2026/thongdi_p                                  */
/* Current: @PAVERSION@ as of @PADATE@/@PALASTAUTHOR@                         */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* DESCRIPTION                                                                */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/* Viewer Listener for s_wkun00.w                                             */
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
&GLOBAL-DEFINE pa-XBasisName       XSC_s_wkun00_w_Lst_cls
&GLOBAL-DEFINE pa-NameSpace        1.00

&GLOBAL-DEFINE pa-Package          x.stamm.cls
&GLOBAL-DEFINE pa-Class            XSC_s_wkun00_w_Lst

/* TODO: Remove this comment and the include below unless you need to reference
         compiler constants in your class. Activate the definition file only if
         necessary to avoid increased compile times.
{basis/incl/b__alp00.cdf}
*/

using x.stamm.cls.XSC_s_wkun00_w_Lst.
using adm.method.cls.DMIUIProcedureEventLst.
using adm.method.cls.DMIWidgetEventLst.
using adm.method.cls.DMIWindowEventLst.
using adm.method.cls.DMCUIProcedureSvo.
using adm.method.cls.DMCWidgetSvo.
using adm.method.cls.DMCWindowSvo.
using adm.method.cls.DMIUIProcedureEventLst.
using adm.method.cls.DMIWidgetEventLst.
using adm.method.cls.DMIWindowEventLst.

class x.stamm.cls.XSC_s_wkun00_w_Lst
  use-widget-pool
  implements DMIUIProcedureEventLst,
             DMIWidgetEventLst,
             DMIWindowEventLst:
  
  define variable goPart     as DMCWidgetSvo no-undo.
  define variable goTelefex  as DMCWidgetSvo no-undo.
  define variable goKunde    as DMCWidgetSvo no-undo.
  
  constructor protected XSC_s_wkun00_w_Lst
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Protected constructor to enforce DI framework usage                    */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    super().
    
  end constructor.
  
  
  method public static XSC_s_wkun00_w_Lst create
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Factory method to create instance via DI framework                     */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    {adm/method/incl/dm_fac01.if}
    
  end method.
  
  
  method public void subscribeWidgetEvents
    ( poUIProcedure as DMCUIProcedureSvo ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Subscription method for widget events.                                 */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poUIProcedure     Ui procedure instance.                               */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    assign
      goPart    = poUIProcedure:oGetWidget('S_Kunde.xVF_FirstPart':U)
      goTelefex = poUIProcedure:oGetWidget('S_Adresse.Telefax':U)
      goKunde   = poUIProcedure:oGetWidget('S_Kunde.Kunde':U)
      .
     
    if valid-object(goPart) then
      goPart:prpoEvents:subscribeOnValueChanged-PostProcessing(this-object, 'OnValueChanged-PostProcessing':U). 
    
  end method.
  
  
  method public void subscribeUIProcedureEvents
    ( poUIProcedure as DMCUIProcedureSvo ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Subscription method for ui procedure events.                           */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poUIProcedure     Ui procedure instance.                               */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    poUIProcedure:prpoEvents:subscribeOnInitialize-PostProcessing(this-object, 'OnInitialize-PostProcessing':U).
    poUIProcedure:prpoEvents:subscribeOnRowAvailable-PostProcessing(this-object, 'OnRowAvailable-PostProcessing':U).
    
  end method.
  
  
  method public void subscribeWindowEvents
    ( poWindow as DMCWindowSvo ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Subscription method for window events.                                 */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poWindow     Window instance.                                          */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
       
  end method.

  method public void OnRowAvailable-PostProcessing
    ( poUIProcedure as DMCUIProcedureSvo ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* OnRowAvailable-PostProcessing                                          */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poUIProcedure                                                          */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
       
    define variable cPartCode     as character no-undo.
    define variable iCustomerCode as integer no-undo.

    if valid-object(goKunde) then
    do:

      iCustomerCode = integer(goKunde:cGetScreenValue()).
      
      if iCustomerCode <> ? then
      do:
                
        cPartCode = this-object:getPart(iCustomerCode).
        
        this-object:updatePartWidgetDisplay(cPartCode).
        
      end.
      
    end.
       
  end method.

  method public void OnInitialize-PostProcessing
    ( poUIProcedure as DMCUIProcedureSvo ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* OnInitialize-PostProcessing                                            */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poUIProcedure                                                          */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    this-object:moveWidget().
    
  end method.


  method public void moveWidget
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* moveWidget                                                             */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* <none>                                                                 */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    if    valid-object (goPart)
      and valid-object (goTelefex) then
    do:
      
      adm.method.cls.DMCUISvc:moveWidgetByPosRef
        ( /* phWidget    */ goPart:prphWidget,
          /* phReference */ goTelefex:prphWidget,
          /* pdColDelta  */ 0,
          /* pdRowDelta  */ 1 ).
    
    end. /* if    valid-object (goSubArtikel)
              and valid-object (goArtikelArt) */
    
  end method.


  method public void updatePartWidgetDisplay
    ( pcPartCode as character ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* getFirstRelatedPart                                                    */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* pcPartCode                                                             */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    define variable cFirstChar as character no-undo.
    
    if valid-object(goPart) then
    do:
      
      goPart:setScreenValue(pcPartCode).  
       
      this-object:evaluateWidgetColor(pcPartCode).
        
    end. /* if valid-object(goPart) */
    
  end method.


  method public character getPart
    ( piCustomer as integer ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* getPart                                                                */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* piCustomer                                                             */
    /*                                                                        */
    /*------------------------------------------------------------------------*/  
    
    define buffer bS_ArtKunde for S_ArtKunde.
    
    find first bS_ArtKunde
      where bS_ArtKunde.Firma = {firma/sartkund.fir pACConnectionSvc:prpcCompany} 
        and bS_ArtKunde.Kunde = piCustomer
      use-index main
      no-lock no-error.
      
    if available bS_ArtKunde then
      return bS_ArtKunde.Artikel.  
            
    return '':U. 
    
  end method.


  method public void OnValueChanged-PostProcessing
    ( poWidget as DMCWidgetSvo ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* OnValueChanged-PostProcessing                                          */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poWidget                                                               */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    this-object:evaluateWidgetColor(goPart:cGetScreenValue()).
    
  end method.


  method public void evaluateWidgetColor
    ( pcPartCode as character ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* evaluateWidgetColor                                                    */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* pcPartCode                                                             */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
        
    define variable cFirstChar as character no-undo.
    
    if valid-object(goPart) then 
    do:
      
      if pcPartCode = '':U or pcPartCode = ? then
      do:
        
        adm.method.cls.DMCUISvc:SetWidgetColor
        (goPart:prphWidget, 
         'bgcolor':U, 
         '':U). 
         return.
         
      end. /* if pcPartCode = '':U */
      
      cFirstChar = substring(pcPartCode, 1, 1).
           
      if index('0123456789':U, cFirstChar) > 0 then
      do:
        
        adm.method.cls.DMCUISvc:SetWidgetColor
        (goPart:prphWidget, 
         'bgcolor':U, 
         'DM_ColorPool_red_1':U).
         
      end. /* if index('0123456789':U, cFirstChar) > 0 */
      
      else
      do:
        
        adm.method.cls.DMCUISvc:SetWidgetColor
        (goPart:prphWidget, 
         'bgcolor':U, 
         'DM_ColorPool_yellow_1':U).
         
      end. /* else */
      
    end. /* if valid-object(goPart) */
    
    
  end method.
  
  
   
end class.