part of '../locations_create_whisper.dart';

class _AddressCreationState extends CSMStateBase { }
final _AddressCreationState _addressState = _AddressCreationState();

class _LocationsCreateAddressForm extends StatelessWidget {
  final TWSArticleCreatorItemState<Location>? itemState;
  final bool enable;

  const _LocationsCreateAddressForm({
    this.itemState,
    this.enable = true,
  });

  @override
  Widget build(BuildContext context) {
    // stores the initial item value.
    return CSMSpacingColumn(
      spacing: 10,
      children: <Widget>[
        CSMDynamicWidget<_AddressCreationState>(
          state: _addressState,
          designer: (BuildContext context, _AddressCreationState state) {
            final Location? item = itemState?.model;
            final bool isEnable = itemState != null &&
                (item?.addressNavigation?.id == 0 ||
                    item?.addressNavigation?.id == null);
            return TWSCascadeSection(
              title: "Address",
              onPressed: (bool isShowing) {
                Location model = itemState!.model;
                itemState?.updateModelRedrawing(
                  model.clone(
                    addressNavigation: Address.a(),
                    address: 0,
                  ),
                );
                state.effect();
              },
              mainControl: Expanded(
                child: TWSAutoCompleteField<Address>(
                  label: 'Select an address',
                  isEnabled: enable,
                  isOptional: true,
                  adapter: const _AddressesViewAdapter(),
                  initialValue: item?.addressNavigation,
                  hasKeyValue: (Address? item) {
                    if (item?.id != null) return item!.id > 0;
                    return false;
                  },
                  displayValue: (Address? item) {
                    return item != null
                        ? "${item.country}/${item.city ?? "-"}/${item.zip ?? "-"}/${item.colonia ?? "-"}/${item.street ?? "-"}"
                        : "Unexpected value";
                  },
                  onChanged: (Address? value) {
                    Location model = itemState!.model;
                    itemState?.updateModelRedrawing(
                      model.clone(
                        address: value?.id ?? 0,
                        addressNavigation: value,
                      ),
                    );
                    state.effect();
                  },
                ),
              ),
              content: CSMSpacingColumn(
                spacing: 10,
                children: <Widget>[
                  const TWSSectionDivider(
                    color: Colors.white,
                    text: "Create an Address",
                  ),
                  CSMSpacingRow(
                    crossAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: <Widget>[
                      
                      Expanded(
                        child: TWSAutoCompleteField<String>(
                          isEnabled: isEnable,
                          localList: _countryOptions,
                          initialValue: item?.addressNavigation?.country == "" ? null :  item?.addressNavigation?.country,
                          displayValue:(String? item) => item ?? "Not valid data",
                          label: 'Country',
                          isOptional: true,
                          onChanged: (String? text) {
                            Location model = itemState!.model;
                            itemState?.updateModelRedrawing(
                              model.clone(
                                addressNavigation: model.addressNavigation?.clone(
                                  country: text,
                                ) ?? Address.a().clone(
                                  country: text,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: TWSAutoCompleteField<String>(
                          isEnabled: isEnable,
                          label: 'State',
                          suffixLabel: " opt.",
                          isOptional: true,
                          localList: const <String>[..._mxStateOptions, ..._usaStateOptions],
                          displayValue: (String? query) => query ?? "---" ,
                          initialValue: item?.addressNavigation?.state == "" ? null :  item?.addressNavigation?.state,
                          onChanged: (String? text) {
                            Location model = itemState!.model;
                            itemState?.updateModelRedrawing(
                              model.clone(
                                addressNavigation: model.addressNavigation?.clone(
                                    state: text,
                                  ) ?? Address.a().clone(
                                    state: text,
                                  ),
                              ),
                            );
                          },              
                        ),
                      ),
                    ],
                  ),
                  CSMSpacingRow(
                    spacing: 10,
                    children: <Widget>[
                      Expanded(
                        child: TWSInputText(
                          maxLength: 100,
                          isEnabled: isEnable,
                          label: 'Street',
                          suffixLabel: ' opt.',
                          isStrictLength: false,
                          controller: TextEditingController(text: item?.addressNavigation?.street),
                          onChanged: (String text) {
                            Location model = itemState!.model;
                            itemState?.updateModelRedrawing(
                              model.clone(
                                addressNavigation: model.addressNavigation?.clone(
                                  street: text,
                                ) ?? Address.a().clone(
                                  street: text,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: TWSInputText(
                          maxLength: 100,
                          isEnabled: isEnable,
                          label: 'Alt. street',
                          suffixLabel: ' opt.',
                          isStrictLength: false,
                          controller: TextEditingController(text: item?.addressNavigation?.altStreet),
                          onChanged: (String text) {
                            Location model = itemState!.model;
                            itemState?.updateModelRedrawing(
                              model.clone(
                                addressNavigation: model.addressNavigation?.clone(
                                  altStreet: text,
                                ) ?? Address.a().clone(
                                  altStreet: text,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ]
                  ),
                  CSMSpacingRow(
                    spacing: 10,
                    children: <Widget>[
                      Expanded(
                        child: TWSInputText(
                          maxLength: 30,
                          isEnabled: isEnable,
                          label: 'City',
                          suffixLabel: ' opt.',
                          isStrictLength: false,
                          controller: TextEditingController(text: item?.addressNavigation?.city),
                          onChanged: (String text) {
                            Location model = itemState!.model;
                            itemState?.updateModelRedrawing(
                              model.clone(
                                addressNavigation: model.addressNavigation?.clone(
                                  city: text,
                                ) ?? Address.a().clone(
                                  city: text,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: TWSInputText(
                          maxLength: 5,
                          isEnabled: isEnable,
                          label: 'ZIP',
                          suffixLabel: ' opt.',
                          isStrictLength: false,
                          controller: TextEditingController(text: item?.addressNavigation?.zip),
                          onChanged: (String text) {
                            Location model = itemState!.model;
                            itemState?.updateModelRedrawing(
                              model.clone(
                                addressNavigation: model.addressNavigation?.clone(
                                  zip: text,
                                ) ?? Address.a().clone(
                                  zip: text,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ]
                  ),
                  CSMSpacingRow(
                    spacing: 10,
                    children: <Widget>[
                      Expanded(
                        child: TWSInputText(
                          maxLength: 30,
                          isEnabled: isEnable,
                          label: 'Colonia',
                          suffixLabel: ' opt.',
                          isStrictLength: false,
                          controller: TextEditingController(text: item?.addressNavigation?.colonia),
                          onChanged: (String text) {
                            Location model = itemState!.model;
                            itemState?.updateModelRedrawing(
                              model.clone(
                                addressNavigation: model.addressNavigation?.clone(
                                  colonia: text,
                                ) ?? Address.a().clone(
                                  colonia: text,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ]
                  ),
                ],
              ),
            );
          },
        ),
        
      ],
    );
  }
}
