/******************************************************************************/
/* @COPYRIGHT@                                                                */
/* Project: Proalpha                                                          */
/*                                                                            */
/* Name   : XSCExportCsvSvc.cls                                               */
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
/* x class for Jop(XSCExportPart-CustomerJob.cls)                             */
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
&GLOBAL-DEFINE pa-XBasisName       XSCExportCsvSvc_cls
&GLOBAL-DEFINE pa-NameSpace        1.00

&GLOBAL-DEFINE pa-Package          x.stamm.cls
&GLOBAL-DEFINE pa-Class            XSCExportCsvSvc

/* TODO: Remove this comment and the include below unless you need to reference
         compiler constants in your class. Activate the definition file only if
         necessary to avoid increased compile times.
{basis/incl/b__alp00.cdf}
*/

using x.stamm.cls.XSCExportCsvSvc.
using adm.method.cls.DMISingletonFrw.

class x.stamm.cls.XSCExportCsvSvc
  use-widget-pool
  implements DMISingletonFrw:
  
  define public static property prpoInstance as XSCExportCsvSvc no-undo
  get:
    {adm/method/incl/dm_sin02.if}
  end get.
  protected set.
  
  
  define stream stExport.
  
  method public void exportDataToCSV
    ( piCustomer like S_Kunde.Kunde ):
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
    this-object:writeExportDetails(piCustomer).    
    this-object:closeExportFile().

  end method.


  method public void validateCustomer
    ( piCustomer like S_Kunde.Kunde ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* validateCustomer                                                       */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* piCustomer                                                             */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    /* Invalid customer number */
    if not can-find (S_Kunde
                       where S_Kunde.Firma   = {firma/s_kunde.fir pACConnectionSvc:prpcCompany}
                         and S_Kunde.Kunde   = piCustomer) then
    do:
      
      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('xskun00001':U).
        
    end. /* if not can-find (S_Kunde) */

    /* No relation parts */
    if not can-find (first S_ArtKunde
                       where S_ArtKunde.Firma   = {firma/sartkund.fir pACConnectionSvc:prpcCompany}
                         and S_ArtKunde.Kunde   = piCustomer) then
    do:

      adm.method.cls.DMCMessageSvc:prpoInstance:showError
        ('xskun00000':U).
            
    end. /* if not can-find (first S_ArtKunde) */
    
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
    
    output stream stExport to 'C:\Users\thongdi_p\Downloads\Part-Customer.csv':U.   
    put stream stExport unformatted 'Customer;Part':U skip.
    
  end method.


  method public void writeExportDetails
    ( piCustomer like S_Kunde.Kunde ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* writeExportDetails                                                     */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* piCustomer                                                             */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    define buffer bS_ArtKunde for S_ArtKunde.

    for each bS_ArtKunde
      where bS_ArtKunde.Firma = {firma/sartkund.fir pACConnectionSvc:prpcCompany}
        and bS_ArtKunde.Kunde = piCustomer
      no-lock 
      by bS_ArtKunde.Artikel:
      
      put stream stExport unformatted 
        bS_ArtKunde.Kunde ';':U 
        bS_ArtKunde.Artikel skip.
        
    end. /* for each bS_ArtKunde */
    
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
  

end class.