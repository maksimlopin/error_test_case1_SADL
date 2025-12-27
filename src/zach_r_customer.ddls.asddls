@AbapCatalog.sqlViewName: 'ZACHRCUSTOMER'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic CDS View for Customer'
@Metadata.ignorePropagatedAnnotations: true
@VDM: {
    viewType: #BASIC
}

define view ZACH_R_CUSTOMER as select from zlxcustomer as Customer
{
    key customerid as Customerid,
    firstname as Firstname,
    lastname as Lastname,
    street as Street,
    postalcode as Postalcode,
    city as City,
    phonenumber as Phonenumber,
    emailaddress as Emailaddress,
    createdby as Createdby,
    createdat as Createdat
}
