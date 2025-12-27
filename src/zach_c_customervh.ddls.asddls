@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help for Customer'

@VDM: {
    viewType: #CONSUMPTION
}

@Search.searchable: true

define view entity ZACH_C_CUSTOMERVH as select from ZACH_R_CUSTOMERTP
{
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
