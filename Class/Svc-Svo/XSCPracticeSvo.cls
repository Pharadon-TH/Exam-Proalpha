/******************************************************************************/
/* @COPYRIGHT@                                                                */
/* Project: Proalpha                                                          */
/*                                                                            */
/* Name   : XSCPracticeSvo.cls                                                */
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
/* Class for  Practice                                                        */
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
&GLOBAL-DEFINE pa-XBasisName       XSCPracticeSvo_cls
&GLOBAL-DEFINE pa-NameSpace        1.00

&GLOBAL-DEFINE pa-Package          x.stamm.cls
&GLOBAL-DEFINE pa-Class            XSCPracticeSvo

/* TODO: Remove this comment and the include below unless you need to reference
         compiler constants in your class. Activate the definition file only if
         necessary to avoid increased compile times.
{basis/incl/b__alp00.cdf}
*/

using x.stamm.cls.XSCPracticeSvo.

class x.stamm.cls.XSCPracticeSvo
  use-widget-pool:
  
  define public property prpcPart            as character no-undo 
    get. set.
  
  define public property prpiPartType        as integer   no-undo 
    get. set.
  
  define public property prpcPartDescription as character no-undo 
    get. set.
  
  define public property prpiCustomerNumber  as integer   no-undo 
    get. set.
  
  define public property prpcCustomerName    as character no-undo 
    get. set.
    
  define public property prpiSupplierNumber  as integer   no-undo 
    get. set.
  
  define public property prpcSupplierName    as character no-undo 
    get. set.
  
  
  {adm/method/incl/dm_fac00.if
    &ippPackage               = "x.stamm.cls"
    &ippClass                 = "XSCPracticeSvo"
    &ippSignature             = "pcS_Artikel_Obj like S_Artikel.S_Artikel_Obj "
    &ippConstructorParameters = "pcS_Artikel_Obj"}
  
    
  constructor public XSCPracticeSvo
    ( pcS_Artikel_Obj like S_Artikel.S_Artikel_Obj ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Protected constructor to enforce DI framework usage                    */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    super().
    
    this-object:loadPartData(pcS_Artikel_Obj).
        
  end constructor.

   
  /*1. Constructor (S_Artikel_Obj)                            */
  /*After create the object, please assigned all of properties*/
  /*- Part                                                    */
  /*- PartType                                                */
  /*- PartDescription (Bezeichnung[1])                        */
  
  method public void loadPartData
    ( pcS_Artikel_Obj like S_Artikel.S_Artikel_Obj ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Separate the code to store and retrieve information.                   */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* pcS_Artikel_Obj                                                        */
    /*                                                                        */
    /*------------------------------------------------------------------------*/

    define buffer bS_Artikel    for S_Artikel.
    define buffer bS_ArtikelSpr for S_ArtikelSpr.
    
        
    find bS_Artikel 
      where bS_Artikel.S_Artikel_Obj = pcS_Artikel_Obj
      no-lock no-error.
         
    if available bS_Artikel then 
    do:
      assign
        this-object:prpcPart     = bS_Artikel.Artikel
        this-object:prpiPartType = bS_Artikel.ArtikelArt
        .            
        
      find first bS_ArtikelSpr 
        where bS_ArtikelSpr.Firma   = {firma/sartikel.fir pACConnectionSvc:prpcCompany}
          and bS_ArtikelSpr.Artikel = bS_Artikel.Artikel
          and bS_ArtikelSpr.Sprache = 'D':U
        no-lock no-error.
             
      if available bS_ArtikelSpr then 
      do:
        this-object:prpcPartDescription = bS_ArtikelSpr.Bezeichnung[1].
      end.
    end.
    
  end method.

  /*2. Export all parts that have relations with at least one customer (use ; as the delimiter in the csv file)*/
  /*Columns → Part, CustomerNumber, CustomerName                                                               */
  /*                                                                                                           */
  /*Part | CustomerNumber | CustomerName                                                                       */
  /*100 | 1000 | proALPHA TH HKT                                                                               */
  /*100 | 1001 | proALPHA TH CNX                                                                               */

  method public void exportCustomerRelation
    ( phStream as handle ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* For export, for customers only.                                        */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* phStream                                                               */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
     
    define buffer bS_ArtKunde for S_ArtKunde.
    define buffer bS_Kunde    for S_Kunde.
    define buffer bS_Adresse  for S_Adresse.    
    
    for each bS_ArtKunde  
      where bS_ArtKunde.Firma   = {firma/sartkund.fir pACConnectionSvc:prpcCompany}
        and bS_ArtKunde.Artikel = this-object:prpcPart
      no-lock:
                
      find first bS_Kunde  
        where bS_Kunde.Firma = {firma/s_kunde.fir pACConnectionSvc:prpcCompany}
          and bS_Kunde.Kunde = bS_ArtKunde.Kunde 
        no-lock no-error.
               
      if available bS_Kunde then 
      do:
        
        assign
          this-object:prpiCustomerNumber = bS_Kunde.Kunde
          this-object:prpcCustomerName   = '':U
          .
        
        find bS_Adresse
          where bS_Adresse.Firma    = {firma/s_adres.fir pACConnectionSvc:prpcCompany}
            and bS_Adresse.AdressNr = bS_Kunde.AdressNr
          no-lock no-error.

        if available bS_Adresse then       
          this-object:prpcCustomerName = bS_Adresse.Name1.
          
        put stream-handle phStream unformatted
          this-object:prpcPart ';':U
          this-object:prpiCustomerNumber ';':U
          this-object:prpcCustomerName skip
          .
           
      end. /* if available S_Kunde */
      
    end. /* for each S_ArtKunde */

  end method. /* exportCustomerRelation */


  /*3. Export all parts that have relations with at least one customer or supplier (use ; as the delimiter in the csv file)*/
  /*Columns → Part, RelationType (String: Customer/Supplier), RelationNumber, RelationName                                 */
  /*                                                                                                                       */
  /*Part | RelationType | RelationNumber | RelationName                                                                    */
  /*100 | Customer | 1000 | proALPHA TH HKT                                                                                */
  /*100 | Customer | 1001 | proALPHA TH CNX                                                                                */
  /*100 | Supplier | 7000 | proALPHA DE                                                                                    */

  method public void exportAllRelation
    ( phStream as handle ):
    /* Description -----------------------------------------------------------*/
    /*                                                                        */
    /* Export (Customer + Supplier)                                           */
    /*                                                                        */
    /* Parameters ------------------------------------------------------------*/
    /*                                                                        */
    /* <none>                                                                 */
    /*                                                                        */
    /*------------------------------------------------------------------------*/
    
    define buffer bS_ArtKunde  for S_ArtKunde.
    define buffer bS_Kunde     for S_Kunde.
    define buffer bS_Adresse   for S_Adresse. 
    
    define buffer bE_ArtLief   for E_ArtLief.
    define buffer bS_Lieferant for S_Lieferant. 
    
    /*find Customer*/
    for each bS_ArtKunde  
      where bS_ArtKunde.Firma   = {firma/sartkund.fir pACConnectionSvc:prpcCompany}
        and bS_ArtKunde.Artikel = this-object:prpcPart
      no-lock:
         
      find first bS_Kunde  
        where bS_Kunde.Firma = {firma/s_kunde.fir pACConnectionSvc:prpcCompany}
          and bS_Kunde.Kunde = bS_ArtKunde.Kunde 
        no-lock no-error.
               
      if available bS_Kunde then 
      do:
        assign
          this-object:prpiCustomerNumber = bS_Kunde.Kunde
          this-object:prpcCustomerName   = '':U
          .
        
        find bS_Adresse
          where bS_Adresse.Firma    = {firma/s_adres.fir pACConnectionSvc:prpcCompany}
            and bS_Adresse.AdressNr = bS_Kunde.AdressNr
          no-lock no-error.

        if available bS_Adresse then       
          this-object:prpcCustomerName = bS_Adresse.Name1.
          
        put stream-handle phStream unformatted
          this-object:prpcPart ';':U
          'Customer' ';':U
          this-object:prpiCustomerNumber ';':U
          this-object:prpcCustomerName skip
          .
           
      end. /* if available S_Kunde */
    end. /* for each S_ArtKunde */ 
     
    /*find Supplier*/
    for each bE_ArtLief
      where bE_ArtLief.Firma   = {firma/e_artli.fir pACConnectionSvc:prpcCompany}
        and bE_ArtLief.Artikel = this-object:prpcPart
      no-lock:
      
      find bS_Lieferant
        where bS_Lieferant.Firma     = {firma/sliefera.fir pACConnectionSvc:prpcCompany}
          and bS_Lieferant.Lieferant = bE_ArtLief.Lieferant
        no-lock no-error.
      
      if available bS_Lieferant then
      do:
        
        assign
          this-object:prpiSupplierNumber = bS_Lieferant.Lieferant
          this-object:prpcSupplierName   = '':U
          .
         
         find bS_Adresse
           where bS_Adresse.Firma    = {firma/s_adres.fir pACConnectionSvc:prpcCompany}
             and bS_Adresse.AdressNr = bS_Lieferant.AdressNr
           no-lock no-error.

         if available bS_Adresse then       
           this-object:prpcSupplierName = bS_Adresse.Name1.
        
         put stream-handle phStream unformatted 
           this-object:prpcPart ';':U  
           'Supplier' ';':U
           this-object:prpiSupplierNumber ';':U
           this-object:prpcSupplierName skip 
           .
           
      end. /* if available S_Lieferant */
      
    end. /* for each E_ArtLief */   
        
  end method. /* exportAllRelation */
      
end class.