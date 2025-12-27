@AbapCatalog.sqlViewName: 'ZACHRTRAVEL'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic CDS View for Travel'
@Metadata.ignorePropagatedAnnotations: true
@VDM: {
    viewType: #BASIC
}
define view ZACH_R_TRAVEL as select from zlxtravel as Travel
    association [0..*] to ZACH_R_BOOKING as _Booking on $projection.Traveluuid = _Booking.Traveluuid
    association [1..1] to ZACH_R_CUSTOMER as _Customer on $projection.Customerid = _Customer.Customerid
{
    key traveluuid as Traveluuid,
    travelid as Travelid,
    customerid as Customerid,
    begindate as Begindate,
    enddate as Enddate,
    bookingfee as Bookingfee,
    totalprice as Totalprice,
    currencycode as Currencycode,
    overallstatus as Overallstatus,
    description as Description,
    createdby as Createdby,
    createdat as Createdat,
    lastchangedby as Lastchangedby,
    lastchangedat as Lastchangedat,
    locallastchangedat as Locallastchangedat,
    
    _Booking,
    _Customer
}
