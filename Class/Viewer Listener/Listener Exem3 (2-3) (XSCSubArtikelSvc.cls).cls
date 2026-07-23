/******************************************************************************/
/* @COPYRIGHT@                                                                */
/* Project: Proalpha                                                          */
/*                                                                            */
/* Name   : XSCSubArtikelSvc.cls                                              */
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
/* Viewer for s_wart00.w                                                      */
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
&GLOBAL-DEFINE pa-XBasisName       XSCSubArtikelSvc_cls
&GLOBAL-DEFINE pa-NameSpace        1.00

&GLOBAL-DEFINE pa-Package          x.stamm.cls
&GLOBAL-DEFINE pa-Class            XSCSubArtikelSvc

/* TODO: Remove this comment and the include below unless you need to reference
         compiler constants in your class. Activate the definition file only if
         necessary to avoid increased compile times.
{basis/incl/b__alp00.cdf}
*/

using x.stamm.cls.XSCSubArtikelSvc.
using adm.method.cls.DMISingletonFrw.

class x.stamm.cls.XSCSubArtikelSvc
  use-widget-pool
  implements DMISingletonFrw:
  
  define public static property prpoInstance as XSCSubArtikelSvc no-undo
  get:
    {adm/method/incl/dm_sin02.if}
  end get.
  protected set.
  
   
  method public void messageSubArtikelnotownmother
    ( pcArtikel    like S_Artikel.Artikel,
      pcSubArtikel as character):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Part A -> xSubArtikel can't assigned Part A                            */
    /* Part A -> xSubArtikel assigned Part B                                  */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* pcArtikel                                                              */
    /* pcSubArtikel                                                           */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
        
    if pcSubArtikel <> '' then
    do:
      
      if pcSubArtikel = pcArtikel then
        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('xsart00000':U).       

    end. /* if pcSubArtikel <> '' */
    
  end method.


  method public void messageSubArtikelnotdatainArtikel
    ( pcSubArtikel as character ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* The xSubArtikel can only be assigned the parts that already exist      */
    /* within the company.                                                    */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* pcSubArtikel                                                           */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    define buffer bS_Artikel for S_Artikel.  
    
    if pcSubArtikel <> '' then
    do:
      
      find bS_Artikel
        where bS_Artikel.Firma    = {firma/sartikel.fir pACConnectionSvc:prpcCompany} 
          and bS_Artikel.Artikel  = pcSubArtikel
        no-lock no-error.
      
      if not available bS_Artikel then
        adm.method.cls.DMCMessageSvc:prpoInstance:showError
          ('xsart00001':U).
          
    end. /* if pcSubArtikel <> '' */

  end method.


  method public void messageSubArtikelnotchildtochildisownmother
    ( pcArtikel    like S_Artikel.Artikel,
      pcSubArtikel as character ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Part B -> xSubArtikel can't assigned Part A and Part B                 */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* pcSubArtikel                                                           */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    define buffer bS_Artikel for S_Artikel.  
    
    if pcSubArtikel <> '' then
    do:

      find bS_Artikel
        where bS_Artikel.Firma   = {firma/sartikel.fir pACConnectionSvc:prpcCompany} 
          and bS_Artikel.Artikel = pcSubArtikel
        no-lock no-error.

      if available bS_Artikel then
      do:
	  
        cSubArtikel = basis.base.cls.BMCAddDataSvc:cValue
                          (bS_Artikel.S_Artikel_Obj, 
                           'xVF_SubArtikel':U).
        
        if cSubArtikel = pcArtikel then
        do:
          
          adm.method.cls.DMCMessageSvc:prpoInstance:showError
            ('xsart00002':U).

        end. /* if string */
        
      end. /* if available bS_Artikel */
      
    end. /* if pcSubArtikel <> '' */
    
  end method.
  
  
end class.