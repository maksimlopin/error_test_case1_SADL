@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Transactional View for Booking'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
@VDM.viewType: #TRANSACTIONAL
define view entity ZACH_R_BOOKINGTP
  as select from ZACH_R_BOOKING
  association to parent ZACH_R_TRAVELTP as _Travel on $projection.Traveluuid = _Travel.Traveluuid
  association [0..1] to ZACH_R_CUSTOMERTP      as _Customer on $projection.Customerid = _Customer.Customerid

{
      @Search.defaultSearchElement: true
  key Bookinguuid,
      Traveluuid,
      Bookingid,
      Bookingdate,
      Customerid,
      Flightdate,
      Flightprice,
      Currencycode,
      Createdby,
      Lastchangedby,
      Locallastchangedat,
      /* Associations */
      _Customer,
      _Travel
}
