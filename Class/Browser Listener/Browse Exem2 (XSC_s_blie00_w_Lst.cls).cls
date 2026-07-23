/******************************************************************************/
/* @COPYRIGHT@                                                                */
/* Project: Proalpha                                                          */
/*                                                                            */
/* Name   : XSC_s_blie00_w_Lst.cls                                            */
/* Product: X - Individualanpassungen extern                                  */
/* Module : STAMM - Übergreifende Stammdaten                                  */
/*                                                                            */
/* Created: 9.5.0 as of 15.06.2026/thongdi_p                                  */
/* Current: @PAVERSION@ as of @PADATE@/@PALASTAUTHOR@                         */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* DESCRIPTION                                                                */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/* Browser Listener for s_blie00.w                                            */
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
&GLOBAL-DEFINE pa-XBasisName       XSC_s_blie00_w_Lst_cls
&GLOBAL-DEFINE pa-NameSpace        1.00

&GLOBAL-DEFINE pa-Package          x.stamm.cls
&GLOBAL-DEFINE pa-Class            XSC_s_blie00_w_Lst

/* TODO: Remove this comment and the include below unless you need to reference
         compiler constants in your class. Activate the definition file only if
         necessary to avoid increased compile times.
{basis/incl/b__alp00.cdf}
*/

using x.stamm.cls.XSC_s_blie00_w_Lst.
using adm.method.cls.DMIBrowseEventLst.
using adm.method.cls.DMIUIProcedureEventLst.
using adm.method.cls.DMIWindowEventLst.
using adm.method.cls.DMCBrowseSvo.
using adm.method.cls.DMCUIProcedureSvo.
using adm.method.cls.DMCWindowSvo.
using adm.method.cls.DMIBrowseEventLst.
using adm.method.cls.DMIUIProcedureEventLst.
using adm.method.cls.DMIWindowEventLst.
using adm.method.cls.DMCWidgetSvo.

class x.stamm.cls.XSC_s_blie00_w_Lst
  use-widget-pool
  implements DMIBrowseEventLst,
             DMIUIProcedureEventLst,
             DMIWindowEventLst:

  define variable ghS_Lieferant as handle no-undo.
  
  constructor protected XSC_s_blie00_w_Lst
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Protected constructor to enforce DI framework usage                    */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    super().
    
  end constructor.
  
  
  method public static XSC_s_blie00_w_Lst create
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Factory method to create instance via DI framework                     */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    {adm/method/incl/dm_fac01.if}
    
  end method.
  
  
  method public void subscribeBrowseEvents
    ( poBrowse as DMCBrowseSvo ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Subscription method for browse procedure events.                       */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poBrowse     Browse procedure instance.                                */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    poBrowse:prpoEventsBrowse:subscribeOnRowDisplay-PostProcessing(this-object, 'OnRowDisplay-PostProcessing':U).
    
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

  method public void OnRowDisplay-PostProcessing
    ( poBrowse as DMCBrowseSvo ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* OnRowDisplay-PostProcessing                                            */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poBrowse                                                               */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
     
    define variable cABCValue     as character    no-undo.
    define variable cColor        as character    no-undo.
   
    if valid-object(poBrowse) then
    do:
      
      ghS_Lieferant = poBrowse:hBuffer().
      
      if valid-handle(ghS_Lieferant) then
      do:
        
        cABCValue = ghS_Lieferant::ABC_Klasse.
        
        case cABCValue:
          when 'A':U then cColor = 'DM_ColorPool_red_1':U.
          when 'B':U then cColor = 'DM_ColorPool_green_1':U.
          when 'C':U then cColor = 'DM_ColorPool_blue160_6':U.
          otherwise       cColor = '':U. 
        end case.
        
        poBrowse:setCellColor('S_Lieferant.ABC_Klasse':U, cColor).
        
      end. /* if valid-handle(ghS_Lieferant) */
    end. /* if valid-object(poBrowse) */
          

  end method.
  
  
end class.