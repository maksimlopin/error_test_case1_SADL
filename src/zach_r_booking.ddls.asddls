@AbapCatalog.sqlViewName: 'ZACHRBOOKING'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Basic CDS View for Booking'
@Metadata.ignorePropagatedAnnotations: true
@VDM: {
    viewType: #BASIC
}
define view ZACH_R_BOOKING as select from zlxbooking as Booking

association [1..1] to ZACH_R_TRAVEL as _Travel on $projection.Traveluuid = _Travel.Traveluuid
association [0..1] to ZACH_R_CUSTOMER as _Customer on $projection.Customerid = _Customer.Customerid
{
    key bookinguuid as Bookinguuid,
    traveluuid as Traveluuid,
    bookingid as Bookingid,
    bookingdate as Bookingdate,
    customerid as Customerid,
    flightdate as Flightdate,
    flightprice as Flightprice,
    currencycode as Currencycode,
    createdby as Createdby,
    lastchangedby as Lastchangedby,
    locallastchangedat as Locallastchangedat,
    
    _Travel,
    _Customer
}
