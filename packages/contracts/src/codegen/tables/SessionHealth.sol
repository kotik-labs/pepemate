// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { FieldLayout } from "@latticexyz/store/src/FieldLayout.sol";
import { Schema } from "@latticexyz/store/src/Schema.sol";
import { EncodedLengths, EncodedLengthsLib } from "@latticexyz/store/src/EncodedLengths.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";

// Import user types
import { Entity } from "../../Entity.sol";

library SessionHealth {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "pepemate", name: "SessionHealth", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x7462706570656d61746500000000000053657373696f6e4865616c7468000000);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x0000000100000000000000000000000000000000000000000000000000000000);

  // Hex-encoded key schema of (bytes32)
  Schema constant _keySchema = Schema.wrap(0x002001005f000000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (uint8[])
  Schema constant _valueSchema = Schema.wrap(0x0000000162000000000000000000000000000000000000000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](1);
    keyNames[0] = "id";
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](1);
    fieldNames[0] = "health";
  }

  /**
   * @notice Register the table with its config.
   */
  function register() internal {
    StoreSwitch.registerTable(_tableId, _fieldLayout, _keySchema, _valueSchema, getKeyNames(), getFieldNames());
  }

  /**
   * @notice Register the table with its config.
   */
  function _register() internal {
    StoreCore.registerTable(_tableId, _fieldLayout, _keySchema, _valueSchema, getKeyNames(), getFieldNames());
  }

  /**
   * @notice Get health.
   */
  function getHealth(Entity id) internal view returns (uint8[4] memory health) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 0);
    return toStaticArray_uint8_4(SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_uint8());
  }

  /**
   * @notice Get health.
   */
  function _getHealth(Entity id) internal view returns (uint8[4] memory health) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 0);
    return toStaticArray_uint8_4(SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_uint8());
  }

  /**
   * @notice Get health.
   */
  function get(Entity id) internal view returns (uint8[4] memory health) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 0);
    return toStaticArray_uint8_4(SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_uint8());
  }

  /**
   * @notice Get health.
   */
  function _get(Entity id) internal view returns (uint8[4] memory health) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 0);
    return toStaticArray_uint8_4(SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_uint8());
  }

  /**
   * @notice Set health.
   */
  function setHealth(Entity id, uint8[4] memory health) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 0, EncodeArray.encode(fromStaticArray_uint8_4(health)));
  }

  /**
   * @notice Set health.
   */
  function _setHealth(Entity id, uint8[4] memory health) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.setDynamicField(_tableId, _keyTuple, 0, EncodeArray.encode(fromStaticArray_uint8_4(health)));
  }

  /**
   * @notice Set health.
   */
  function set(Entity id, uint8[4] memory health) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 0, EncodeArray.encode(fromStaticArray_uint8_4(health)));
  }

  /**
   * @notice Set health.
   */
  function _set(Entity id, uint8[4] memory health) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.setDynamicField(_tableId, _keyTuple, 0, EncodeArray.encode(fromStaticArray_uint8_4(health)));
  }

  // The length of health
  uint256 constant lengthHealth = 4;

  // The length of health
  uint256 constant length = 4;

  /**
   * @notice Get an item of health.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemHealth(Entity id, uint256 _index) internal view returns (uint8) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 0);
    uint256 dynamicLength = _byteLength / 1;
    uint256 staticLength = 4;

    if (_index < staticLength && _index >= dynamicLength) {
      return (uint8(bytes1(new bytes(0))));
    }

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (uint8(bytes1(_blob)));
    }
  }

  /**
   * @notice Get an item of health.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemHealth(Entity id, uint256 _index) internal view returns (uint8) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 0);
    uint256 dynamicLength = _byteLength / 1;
    uint256 staticLength = 4;

    if (_index < staticLength && _index >= dynamicLength) {
      return (uint8(bytes1(new bytes(0))));
    }

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (uint8(bytes1(_blob)));
    }
  }

  /**
   * @notice Get an item of health.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItem(Entity id, uint256 _index) internal view returns (uint8) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 0);
    uint256 dynamicLength = _byteLength / 1;
    uint256 staticLength = 4;

    if (_index < staticLength && _index >= dynamicLength) {
      return (uint8(bytes1(new bytes(0))));
    }

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (uint8(bytes1(_blob)));
    }
  }

  /**
   * @notice Get an item of health.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItem(Entity id, uint256 _index) internal view returns (uint8) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 0);
    uint256 dynamicLength = _byteLength / 1;
    uint256 staticLength = 4;

    if (_index < staticLength && _index >= dynamicLength) {
      return (uint8(bytes1(new bytes(0))));
    }

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 1, (_index + 1) * 1);
      return (uint8(bytes1(_blob)));
    }
  }

  /**
   * @notice Update an element of health at `_index`.
   */
  function updateHealth(Entity id, uint256 _index, uint8 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update an element of health at `_index`.
   */
  function _updateHealth(Entity id, uint256 _index, uint8 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update an element of health at `_index`.
   */
  function update(Entity id, uint256 _index, uint8 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update an element of health at `_index`.
   */
  function _update(Entity id, uint256 _index, uint8 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 1), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord(Entity id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord(Entity id) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack dynamic data lengths using this table's schema.
   * @return _encodedLengths The lengths of the dynamic fields (packed into a single bytes32 value).
   */
  function encodeLengths(uint8[4] memory health) internal pure returns (EncodedLengths _encodedLengths) {
    // Lengths are effectively checked during copy by 2**40 bytes exceeding gas limits
    unchecked {
      _encodedLengths = EncodedLengthsLib.pack(health.length * 1);
    }
  }

  /**
   * @notice Tightly pack dynamic (variable length) data using this table's schema.
   * @return The dynamic data, encoded into a sequence of bytes.
   */
  function encodeDynamic(uint8[4] memory health) internal pure returns (bytes memory) {
    return abi.encodePacked(EncodeArray.encode(fromStaticArray_uint8_4(health)));
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(uint8[4] memory health) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData;
    EncodedLengths _encodedLengths = encodeLengths(health);
    bytes memory _dynamicData = encodeDynamic(health);

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple(Entity id) internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = Entity.unwrap(id);

    return _keyTuple;
  }
}

/**
 * @notice Cast a dynamic array to a static array.
 * @dev In memory static arrays are just dynamic arrays without the 32 length bytes,
 * so this function moves the pointer to the first element of the dynamic array.
 * If the length of the dynamic array is smaller than the static length,
 * the function returns an uninitialized array to avoid memory corruption.
 * @param _value The dynamic array to cast.
 * @return _result The static array.
 */
function toStaticArray_uint8_4(uint8[] memory _value) pure returns (uint8[4] memory _result) {
  if (_value.length < 4) {
    // return an uninitialized array if the length is smaller than the fixed length to avoid memory corruption
    return _result;
  } else {
    // in memory static arrays are just dynamic arrays without the 32 length bytes
    // (without the length check this could lead to memory corruption)
    assembly {
      _result := add(_value, 0x20)
    }
  }
}

/**
 * @notice Copy a static array to a dynamic array.
 * @dev Static arrays don't have a length prefix, so this function copies the memory from the static array to a new dynamic array.
 * @param _value The static array to copy.
 * @return _result The dynamic array.
 */
function fromStaticArray_uint8_4(uint8[4] memory _value) pure returns (uint8[] memory _result) {
  _result = new uint8[](4);
  uint256 fromPointer;
  uint256 toPointer;
  assembly {
    fromPointer := _value
    toPointer := add(_result, 0x20)
  }
  Memory.copy(fromPointer, toPointer, 128);
}
