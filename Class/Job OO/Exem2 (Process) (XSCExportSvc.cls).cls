/******************************************************************************/
/* @COPYRIGHT@                                                                */
/* Project: Proalpha                                                          */
/*                                                                            */
/* Name   : XSCExportSvc.cls                                                  */
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
/* Export csv for XSCExportPartsJob.cls                                       */
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
&GLOBAL-DEFINE pa-XBasisName       XSCExportSvc_cls
&GLOBAL-DEFINE pa-NameSpace        1.00

&GLOBAL-DEFINE pa-Package          x.stamm.cls
&GLOBAL-DEFINE pa-Class            XSCExportSvc

/* TODO: Remove this comment and the include below unless you need to reference
         compiler constants in your class. Activate the definition file only if
         necessary to avoid increased compile times.
{basis/incl/b__alp00.cdf}
*/

using x.stamm.cls.XSCExportSvc.
using adm.method.cls.DMISingletonFrw.

class x.stamm.cls.XSCExportSvc
  use-widget-pool
  implements DMISingletonFrw:
  
  define public static property prpoInstance as XSCExportSvc no-undo
  get:
    {adm/method/incl/dm_sin02.if}
  end get.
  protected set.

  define stream stExport.

  method public void validatePart
    ( pcPartmin     like S_Artikel.Artikel,
      pcPartmax     like S_Artikel.Artikel,
      piPartTypemin like S_Artikel.ArtikelArt, 
      piPartTypemax like S_Artikel.ArtikelArt):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* validatePart                                                           */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* <none>                                                                 */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    /* validatePart */
    if not can-find (S_Artikel
                       where S_Artikel.Firma    = {firma/s_kunde.fir pACConnectionSvc:prpcCompany}
                         and S_Artikel.Artikel  = pcPartmin) then
    do:
      
      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('xsart0003':U).
        
    end. /* if not can-find (S_Artikel.Artikel) */
    
    if not can-find (S_Artikel
                       where S_Artikel.Firma    = {firma/s_kunde.fir pACConnectionSvc:prpcCompany}
                         and S_Artikel.Artikel  = pcPartmax) then
    do:
      
      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('xsart0003':U).
        
    end. /* if not can-find (S_Artikel.Artikel) */

    /* validatePartType */
    if not can-find (first S_Artikel
                       where S_Artikel.ArtikelArt  = piPartTypemin) then
    do:
      
      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('xsart0004':U).
        
    end. /* if not can-find (first S_Artikel.ArtikelArt) */    

       
    if not can-find (first S_Artikel
                       where S_Artikel.ArtikelArt  = piPartTypemax) then
    do:
      
      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('xsart0004':U).
        
    end. /* if not can-find (first S_Artikel.ArtikelArt) */
        
  end method.


  method public void initializeExportFile
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* initializeExportFile                                                   */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* <none>                                                                 */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    output stream stExport to 'C:\Users\thongdi_p\Downloads\PartPartTypeCustomer.csv':U.   
    put stream stExport unformatted 'Part;PartType;Customer':U skip.
    
  end method.


  method public void writeExportDetails
    ( pcPartMin     like S_Artikel.Artikel,
      pcPartMax     like S_Artikel.Artikel,
      piPartTypeMin like S_Artikel.ArtikelArt,
      piPartTypeMax like S_Artikel.ArtikelArt,
      plCheck       as logical ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* exportPartsData                                                        */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* pcPartMin                                                              */
    /* pcPartMax                                                              */
    /* piPartTypeMin                                                          */
    /* piPartTypeMax                                                          */
    /* plCheck                                                                */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    define buffer bS_Artikel  for S_Artikel.
    define buffer bS_ArtKunde for S_ArtKunde.
    define variable cCustomer as character no-undo.
    
    for each bS_Artikel 
        where bS_Artikel.Firma      = {firma/sartikel.fir pACConnectionSvc:prpcCompany}
          and bS_Artikel.Artikel    >= pcPartMin
          and bS_Artikel.Artikel    <= pcPartMax
          and bS_Artikel.ArtikelArt >= piPartTypeMin
          and bS_Artikel.ArtikelArt <= piPartTypeMax 
          no-lock:
          
        assign cCustomer = '':U.
        
        find first bS_ArtKunde
          where bS_ArtKunde.Firma   = {firma/sartkund.fir pACConnectionSvc:prpcCompany}
            and bS_ArtKunde.Artikel = bS_Artikel.Artikel
          no-lock no-error.
            
        if plCheck = true then
        do:
          
         if not available bS_ArtKunde then
           next.
           
        end.
                
        if available bS_ArtKunde then
            cCustomer = string(bS_ArtKunde.Kunde).
            
        put stream stExport unformatted
            bS_Artikel.Artikel ';':U
            bS_Artikel.ArtikelArt ';':U
            cCustomer skip
            .
            
    end. /* for each bS_Artikel */
    
  end method.
  
  
  method public void closeExportFile
    (  ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* closeExportFile                                                        */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* <none>                                                                 */
    /*                                                                        */
    /*------------------------------------------------------------------------*/

    output stream stExport close.

  end method.
  
  method public void exportDataToCSV
    ( pcPartMin     like S_Artikel.Artikel,
      pcPartMax     like S_Artikel.Artikel,
      piPartTypeMin like S_Artikel.ArtikelArt,
      piPartTypeMax like S_Artikel.ArtikelArt,
      plCheck       as logical ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* exportDataToCSV                                                        */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* piCustomer                                                             */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    this-object:initializeExportFile().    
    this-object:writeExportDetails(pcPartMin,pcPartMax,piPartTypeMin,piPartTypeMax,plCheck).    
    this-object:closeExportFile().

  end method.
  
  
  
end class.