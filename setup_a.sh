#!/bin/bash

pip install -e . --config-settings editable_mode=compat
cd ChamferDistancePytorch/chamfer3D
python setup.py install

cd ../../