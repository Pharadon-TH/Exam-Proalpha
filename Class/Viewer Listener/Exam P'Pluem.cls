/******************************************************************************/
/* @COPYRIGHT@                                                                */
/* Project: Proalpha                                                          */
/*                                                                            */
/* Name   : XSC_s_wart08_w_Lst.cls                                            */
/* Product: X - Individualanpassungen extern                                  */
/* Module : STAMM - Übergreifende Stammdaten                                  */
/*                                                                            */
/* Created: 9.5.0 as of 09.06.2026/thongdi_p                                  */
/* Current: @PAVERSION@ as of @PADATE@/@PALASTAUTHOR@                         */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* DESCRIPTION                                                                */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/* Viewer Listener for s_wart08.w                                             */
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
&GLOBAL-DEFINE pa-XBasisName       XSC_s_wart08_w_Lst_cls
&GLOBAL-DEFINE pa-NameSpace        1.00

&GLOBAL-DEFINE pa-Package          x.stamm.cls
&GLOBAL-DEFINE pa-Class            XSC_s_wart08_w_Lst

/* TODO: Remove this comment and the include below unless you need to reference
         compiler constants in your class. Activate the definition file only if
         necessary to avoid increased compile times.
{basis/incl/b__alp00.cdf}
*/

using x.stamm.cls.XSC_s_wart08_w_Lst.
using adm.method.cls.DMIUIProcedureEventLst.
using adm.method.cls.DMIWidgetEventLst.
using adm.method.cls.DMIWindowEventLst.
using adm.method.cls.DMCUIProcedureSvo.
using adm.method.cls.DMCWidgetSvo.
using adm.method.cls.DMCWindowSvo.
using adm.method.cls.DMIUIProcedureEventLst.
using adm.method.cls.DMIWidgetEventLst.
using adm.method.cls.DMIWindowEventLst.

class x.stamm.cls.XSC_s_wart08_w_Lst
  use-widget-pool
  implements DMIUIProcedureEventLst,
             DMIWidgetEventLst,
             DMIWindowEventLst:
               
  define variable goPrioritaet              as DMCWidgetSvo no-undo.
  define variable goSelection               as DMCWidgetSvo no-undo.
  define variable goFirstChar               as DMCWidgetSvo no-undo.
  define variable goStandardPartListFromPPA as DMCWidgetSvo no-undo.
  define variable ghS_Artikel               as handle       no-undo.
  
  constructor protected XSC_s_wart08_w_Lst
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Protected constructor to enforce DI framework usage                    */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    super().
    
  end constructor.
  
  
  method public static XSC_s_wart08_w_Lst create
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
      goPrioritaet               = poUIProcedure:oGetWidget('S_Artikel.Prioritaet':U)
      goSelection                = poUIProcedure:oGetWidget('S_Artikel.xVF_Selection':U)
      goStandardPartListFromPPA  = poUIProcedure:oGetWidget('S_Artikel.StandardPartListFromPPA':U)
      goFirstChar                = poUIProcedure:oGetWidget('cxFirstChar':U)
      .
    
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
    
    assign
      ghS_Artikel = poUIProcedure:hBufferHandleForTable('S_Artikel':U)
      .
      
    if    valid-handle (ghS_Artikel)
      and valid-object (goFirstChar) then
    do:
      
      goFirstChar:setScreenValue(substring(ghS_Artikel::Artikel, 1, 1)).
      
    end. /* if valid-handle(ghS_Artikel) */
    
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
    
    if valid-object (goPrioritaet) then
    do:
      
      goPrioritaet:setLabel('Priority':U).
      
    end. /* if valid-object (goPrioritaet) */
    
    if    valid-object (goSelection)
      and valid-object (goStandardPartListFromPPA) then
    do:
      
      adm.method.cls.DMCUISvc:moveWidgetByPosRef
        ( /* phWidget    */ goSelection:prphWidget,
          /* phReference */ goStandardPartListFromPPA:prphWidget,
          /* pdColDelta  */ 0,
          /* pdRowDelta  */ 1 ).
    
    end. /* if    valid-object (goSelection)
              and valid-object (goStandardPartListFromPPA) */
    
    if    valid-object (goSelection)
      and valid-object (goFirstChar) then
    do:
      
      adm.method.cls.DMCUISvc:moveWidgetByPosRef
        ( /* phWidget    */ goFirstChar:prphWidget,
          /* phReference */ goSelection:prphWidget,
          /* pdColDelta  */ 0,
          /* pdRowDelta  */ 1 ).
      
    end. /* if    valid-object (goSelection)
              and valid-object (goFirstChar) */

  end method.
  
  
end class.