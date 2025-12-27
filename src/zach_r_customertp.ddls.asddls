@AbapCatalog.sqlViewName: 'ZACHRCUSTOMERTP'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transactional View for Customer'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #TRANSACTIONAL
@Search.searchable: true
define view ZACH_R_CUSTOMERTP
  as select from ZACH_R_CUSTOMER

{
      @Search.defaultSearchElement: true
  key Customerid,
      Firstname,
      Lastname,
      Street,
      Postalcode,
      City,
      Phonenumber,
      Emailaddress,
      Createdby,
      Createdat
}
