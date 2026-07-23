/******************************************************************************/
/* @COPYRIGHT@                                                                */
/* Project: Proalpha                                                          */
/*                                                                            */
/* Name   : XSC_s_wart00_w_Lst.cls                                            */
/* Product: X - Individualanpassungen extern                                  */
/* Module : STAMM - Übergreifende Stammdaten                                  */
/*                                                                            */
/* Created: 9.5.0 as of 10.06.2026/thongdi_p                                  */
/* Current: @PAVERSION@ as of @PADATE@/@PALASTAUTHOR@                         */
/*                                                                            */
/*----------------------------------------------------------------------------*/
/* DESCRIPTION                                                                */
/*----------------------------------------------------------------------------*/
/*                                                                            */
/* Viewer Listener for s_wart00.w                                             */
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
&GLOBAL-DEFINE pa-XBasisName       XSC_s_wart00_w_Lst_cls
&GLOBAL-DEFINE pa-NameSpace        1.00

&GLOBAL-DEFINE pa-Package          x.stamm.cls
&GLOBAL-DEFINE pa-Class            XSC_s_wart00_w_Lst

/* TODO: Remove this comment and the include below unless you need to reference
         compiler constants in your class. Activate the definition file only if
         necessary to avoid increased compile times.
{basis/incl/b__alp00.cdf}
*/

using x.stamm.cls.XSC_s_wart00_w_Lst.
using adm.method.cls.DMIUIProcedureEventLst.
using adm.method.cls.DMIWidgetEventLst.
using adm.method.cls.DMIWindowEventLst.
using adm.method.cls.DMCUIProcedureSvo.
using adm.method.cls.DMCWidgetSvo.
using adm.method.cls.DMCWindowSvo.
using adm.method.cls.DMIUIProcedureEventLst.
using adm.method.cls.DMIWidgetEventLst.
using adm.method.cls.DMIWindowEventLst.
using adm.method.cls.DMCWidgetCreationSvo.

class x.stamm.cls.XSC_s_wart00_w_Lst
  use-widget-pool
  implements DMIUIProcedureEventLst,
             DMIWidgetEventLst,
             DMIWindowEventLst:
  
  define variable goSubArtikel     as DMCWidgetSvo         no-undo.
  define variable goArtikelArt     as DMCWidgetSvo         no-undo.
  define variable goArtikel        as DMCWidgetSvo         no-undo.
  define variable goBtnBezeichnung as DMCWidgetSvo         no-undo.
  define variable goContainer      as DMCUIProcedureSvo    no-undo.
  
    
  constructor protected XSC_s_wart00_w_Lst
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Protected constructor to enforce DI framework usage                    */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    super().
    
  end constructor.
  
  
  method public static XSC_s_wart00_w_Lst create
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Factory method to create instance via DI framework                     */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    {adm/method/incl/dm_fac01.if}
    
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
    
    poUIProcedure:prpoEvents:subscribeOnInitializeLocal-PostProcessing(this-object, 'OnInitializeLocal-PostProcessing':U).
    poUIProcedure:prpoEvents:subscribeOnInitializeLocal-PreProcessing(this-object, 'OnInitializeLocal-PreProcessing':U).
    poUIProcedure:prpoEvents:subscribeOnAssignRecord-PostProcessing(this-object, 'OnAssignRecord-PostProcessing':U).
    poUIProcedure:prpoEvents:subscribeOnRowAvailable-PostProcessing(this-object, 'OnRowAvailable-PostProcessing':U).
    
    poUIProcedure:setHeight(poUIProcedure:prphFrame:height-chars + 0.5).
    
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
      goSubArtikel     = poUIProcedure:oGetWidget('S_Artikel.xVF_SubArtikel':U)
      goArtikelArt     = poUIProcedure:oGetWidget('S_Artikel.ArtikelArt':U)
      goArtikel        = poUIProcedure:oGetWidget('S_Artikel.Artikel':U)
      goBtnBezeichnung = poUIProcedure:oGetWidget('BtnBezeichnung':U)
      .
    
    
    if valid-object(goBtnBezeichnung) then
    do:
      goBtnBezeichnung:prpoEvents:subscribeOnChoose-PostProcessing(this-object, 'OnChoose-PostProcessing':U).
    end.  
      
              
  end method.


  method public void OnInitializeLocal-PostProcessing
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
    
    goContainer = poUIProcedure:prpoWindow:prpoContainer.
    
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
    
    if    valid-object (goSubArtikel)
      and valid-object (goArtikelArt) then
    do:
      
      adm.method.cls.DMCUISvc:moveWidgetByPosRef
        ( /* phWidget    */ goSubArtikel:prphWidget,
          /* phReference */ goArtikelArt:prphWidget,
          /* pdColDelta  */ 0,
          /* pdRowDelta  */ 1 ).
    
    end. /* if    valid-object (goSubArtikel)
              and valid-object (goArtikelArt) */
              
              
    if    valid-object (goBtnBezeichnung) 
      and valid-object (goSubArtikel) then
    do:
      
     
      adm.method.cls.DMCUISvc:moveWidgetByPosRef
        ( /* phWidget    */ goBtnBezeichnung:prphWidget,
          /* phReference */ goSubArtikel:prphWidget,
          /* pdColDelta  */ 0,
          /* pdRowDelta  */ 1 ). 
                   
    end. /* if    valid-object (goSubArtikel)
              and valid-object (goArtikelArt) */          

  end method.


  method public void messageSubArtikelcannotmother
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Part A -> xSubArtikel can't assigned Part A                            */
    /* Part A -> xSubArtikel assigned Part B                                  */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* <none>                                                                 */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    define variable cSubArtikel as character no-undo.
    define variable cArtikel    as character no-undo.
    
    if    valid-object (goSubArtikel) 
      and valid-object (goArtikel) then
    do:
         
      cSubArtikel = goSubArtikel:cGetScreenvalue().
      cArtikel    = goArtikel:cGetScreenvalue().
          
      x.stamm.cls.XSCSubArtikelSvc:prpoInstance:messageSubArtikelnotownmother
        ( /* pcArtikel    */ cArtikel,
          /* pcSubArtikel */ cSubArtikel ).
             
          
    end. /* if    valid-object (goSubArtikel) 
              and valid-object (goArtikel) */
  
  end method.


  method public void OnAssignRecord-PostProcessing
    ( poUIProcedure as DMCUIProcedureSvo ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* OnAssignRecord-PostProcessing                                          */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poUIProcedure                                                          */
    /*                                                                        */
    /*------------------------------------------------------------------------*/

      this-object:messageSubArtikelcannotmother().
      this-object:messageSubArtikelnotdataArtikel().
      this-object:messageSubArtikelchildtochildnotownmother().
      
      if valid-object(goBtnBezeichnung) then
         goBtnBezeichnung:setEnabled( /* plEnabled */ yes ).

  end method.


  method public void messageSubArtikelnotdataArtikel
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* The xSubArtikel can only be assigned the parts that already exist      */
    /* within the company.                                                    */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* <none>                                                                 */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    define variable cSubArtikel as character no-undo.
    
    if valid-object (goSubArtikel) then
    do:
         
      cSubArtikel = goSubArtikel:cGetScreenvalue().
          
      x.stamm.cls.XSCSubArtikelSvc:prpoInstance:messageSubArtikelnotdatainArtikel
        ( /* pcSubArtikel */ cSubArtikel ).
          
    end. /* if valid-object (goSubArtikel) */   
      
  end method.


  method public void messageSubArtikelchildtochildnotownmother
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Part B -> xSubArtikel can't assigned Part A and Part B                 */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* <none>                                                                 */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
       
    define variable cSubArtikel as character no-undo.
    define variable cArtikel    as character no-undo.
    
    if    valid-object (goSubArtikel) 
      and valid-object (goArtikel) then
    do:
         
      cSubArtikel = goSubArtikel:cGetScreenvalue().
      cArtikel    = goArtikel:cGetScreenvalue().
          
      x.stamm.cls.XSCSubArtikelSvc:prpoInstance:messageSubArtikelnotchildtochildisownmother
        ( /* pcArtikel    */ cArtikel,
          /* pcSubArtikel */ cSubArtikel ).
             
          
    end. /* if    valid-object (goSubArtikel) 
              and valid-object (goArtikel) */
              
  end method.

  method public void OnInitializeLocal-PreProcessing
    ( poUIProcedure as DMCUIProcedureSvo ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* OnInitialize-PreProcessing                                             */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poUIProcedure                                                          */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    this-object:addButton(poUIProcedure).
    
  end method.


  method public void addButton
    ( poUIProcedure as DMCUIProcedureSvo ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* addButton                                                              */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poUIProcedure                                                          */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    define variable oBtnBezeichnung as DMCWidgetCreationSvo  no-undo. 
    
    oBtnBezeichnung = new adm.method.cls.DMCWidgetCreationSvo
                             ( /* pcWidgetName */ 'BtnBezeichnung':U,
                               /* pcWidgetType */ 'button':U,
                               /* pcLabel      */ 'SET DESC':U,
                               /* pcDataType   */ ?,
                               /* pcFormat     */ ? ).
                                                      
    poUIProcedure:hCreateWidget
      ( /* poWidgetCreation */ oBtnBezeichnung,
        /* pdRow            */ 1,
        /* pdCol            */ 1 ).
                                                                                           
  end method.
  

  method public void OnChoose-PostProcessing
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* OnChoose-PostProcessing                                                */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* poWidget                                                               */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    define variable cArtikel    as character no-undo.
    define variable cTimestamp  as character no-undo.
    define variable cNewText    as character no-undo.
    
    define buffer bS_ArtikelSpr for S_ArtikelSpr.
    
    assign 
      cTimestamp = string(today, '99.99.9999':U) + ' ':U + string(time, 'hh:mm:ss':U)
      cNewText   = 'PROALPHA':U + ' ':U + cTimestamp 
      .
    
    if valid-object(goArtikel) then
        cArtikel = goArtikel:cGetScreenValue().
        

    if cArtikel > '':U then
    do:

      find bS_ArtikelSpr 
        where bS_ArtikelSpr.Artikel = cArtikel
          and bS_ArtikelSpr.Sprache = 'D':U
        exclusive-lock no-error.
            
      if available bS_ArtikelSpr then
          bS_ArtikelSpr.Bezeichnung[1] = cNewText.
                          
    end. /* if cArtikel > '':U */
    
    if valid-object(goContainer) then
      goContainer:cRunNotify( /* pcMethodName */ 'row-available,container-target':U ).
    

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
    
    if valid-object(goBtnBezeichnung) then
      goBtnBezeichnung:setEnabled( /* plEnabled */ yes ). 
    
  end method.
  
  
  
end class.