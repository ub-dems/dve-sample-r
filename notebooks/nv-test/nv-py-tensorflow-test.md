##### Copyright 2019 The TensorFlow Authors.


```python
#@title Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
```

# TensorFlow 2 quickstart for beginners

<table class="tfo-notebook-buttons" align="left">
  <td>
    <a target="_blank" href="https://www.tensorflow.org/tutorials/quickstart/beginner"><img src="https://www.tensorflow.org/images/tf_logo_32px.png" />View on TensorFlow.org</a>
  </td>
  <td>
    <a target="_blank" href="https://colab.research.google.com/github/tensorflow/docs/blob/master/site/en/tutorials/quickstart/beginner.ipynb"><img src="https://www.tensorflow.org/images/colab_logo_32px.png" />Run in Google Colab</a>
  </td>
  <td>
    <a target="_blank" href="https://github.com/tensorflow/docs/blob/master/site/en/tutorials/quickstart/beginner.ipynb"><img src="https://www.tensorflow.org/images/GitHub-Mark-32px.png" />View source on GitHub</a>
  </td>
  <td>
    <a href="https://storage.googleapis.com/tensorflow_docs/docs/site/en/tutorials/quickstart/beginner.ipynb"><img src="https://www.tensorflow.org/images/download_logo_32px.png" />Download notebook</a>
  </td>
</table>

This short introduction uses [Keras](https://www.tensorflow.org/guide/keras/overview) to:

1. Load a prebuilt dataset.
1. Build a neural network machine learning model that classifies images.
2. Train this neural network.
3. Evaluate the accuracy of the model.

This tutorial is a [Google Colaboratory](https://colab.research.google.com/notebooks/welcome.ipynb) notebook. Python programs are run directly in the browser—a great way to learn and use TensorFlow. To follow this tutorial, run the notebook in Google Colab by clicking the button at the top of this page.

1. In Colab, connect to a Python runtime: At the top-right of the menu bar, select *CONNECT*.
2. To run all the code in the notebook, select **Runtime** > **Run all**. To run the code cells one at a time, hover over each cell and select the **Run cell** icon.

![Run cell icon](images/beginner/run_cell_icon.png)

## Set up TensorFlow

Import TensorFlow into your program to get started:

@see: https://macjim.medium.com/loading-alternative-cudnn-library-versions-in-tensorflow-90c7472e361a


```python
import os
os.environ["TF_CPP_MIN_LOG_LEVEL"] = "0"  # DEBUG, INFO, WARNING, ERROR: 0 ~ 3
```


```python
!nvidia-smi -L
```

    GPU 0: Tesla V100-PCIE-16GB (UUID: GPU-1963a9d7-8ed4-7459-78f2-b4394f0a1acb)



```python
import tensorflow as tf

print("TensorFlow version:", tf.__version__)
print(tf.config.list_physical_devices('GPU'))

```

    2025-03-20 16:48:18.451577: E external/local_xla/xla/stream_executor/cuda/cuda_fft.cc:467] Unable to register cuFFT factory: Attempting to register factory for plugin cuFFT when one has already been registered
    WARNING: All log messages before absl::InitializeLog() is called are written to STDERR
    E0000 00:00:1742485698.473029   82189 cuda_dnn.cc:8579] Unable to register cuDNN factory: Attempting to register factory for plugin cuDNN when one has already been registered
    E0000 00:00:1742485698.479591   82189 cuda_blas.cc:1407] Unable to register cuBLAS factory: Attempting to register factory for plugin cuBLAS when one has already been registered
    W0000 00:00:1742485698.496738   82189 computation_placer.cc:177] computation placer already registered. Please check linkage and avoid linking the same target more than once.
    W0000 00:00:1742485698.496754   82189 computation_placer.cc:177] computation placer already registered. Please check linkage and avoid linking the same target more than once.
    W0000 00:00:1742485698.496757   82189 computation_placer.cc:177] computation placer already registered. Please check linkage and avoid linking the same target more than once.
    W0000 00:00:1742485698.496758   82189 computation_placer.cc:177] computation placer already registered. Please check linkage and avoid linking the same target more than once.
    2025-03-20 16:48:18.502709: I tensorflow/core/platform/cpu_feature_guard.cc:210] This TensorFlow binary is optimized to use available CPU instructions in performance-critical operations.
    To enable the following instructions: AVX2 FMA, in other operations, rebuild TensorFlow with the appropriate compiler flags.


    TensorFlow version: 2.19.0
    [PhysicalDevice(name='/physical_device:GPU:0', device_type='GPU')]



```python
print(tf.reduce_sum(tf.random.normal([1000, 1000])))
```

    tf.Tensor(-623.6317, shape=(), dtype=float32)


    I0000 00:00:1742485702.762730   82189 gpu_device.cc:2019] Created device /job:localhost/replica:0/task:0/device:GPU:0 with 14784 MB memory:  -> device: 0, name: Tesla V100-PCIE-16GB, pci bus id: 0001:00:00.0, compute capability: 7.0



```python
try:
    with tf.device('/GPU:0'):  # Specify GPU device
        a = tf.constant([1.0, 2.0, 3.0, 4.0])
        b = tf.constant([2.0, 2.0, 2.0, 2.0])
        c = a + b
        print("Result of GPU operation:", c.numpy())
except RuntimeError as e:
    print("Error using GPU:", e)
```

    Result of GPU operation: [3. 4. 5. 6.]


If you are following along in your own development environment, rather than [Colab](https://colab.research.google.com/github/tensorflow/docs/blob/master/site/en/tutorials/quickstart/beginner.ipynb), see the [install guide](https://www.tensorflow.org/install) for setting up TensorFlow for development.

Note: Make sure you have upgraded to the latest `pip` to install the TensorFlow 2 package if you are using your own development environment. See the [install guide](https://www.tensorflow.org/install) for details.

## Load a dataset

Load and prepare the MNIST dataset. The pixel values of the images range from 0 through 255. Scale these values to a range of 0 to 1 by dividing the values by `255.0`. This also converts the sample data from integers to floating-point numbers:


```python
mnist = tf.keras.datasets.mnist

(x_train, y_train), (x_test, y_test) = mnist.load_data()
x_train, x_test = x_train / 255.0, x_test / 255.0
```

## Build a machine learning model

Build a `tf.keras.Sequential` model:


```python
model = tf.keras.models.Sequential([
  tf.keras.layers.Flatten(input_shape=(28, 28)),
  tf.keras.layers.Dense(128, activation='relu'),
  tf.keras.layers.Dropout(0.2),
  tf.keras.layers.Dense(10)
])
```

    /home/gp21012/.cache/pypoetry/virtualenvs/dve-sample-r-x2RGOxK1-py3.12/lib/python3.12/site-packages/keras/src/layers/reshaping/flatten.py:37: UserWarning: Do not pass an `input_shape`/`input_dim` argument to a layer. When using Sequential models, prefer using an `Input(shape)` object as the first layer in the model instead.
      super().__init__(**kwargs)


[`Sequential`](https://www.tensorflow.org/guide/keras/sequential_model) is useful for stacking layers where each layer has one input [tensor](https://www.tensorflow.org/guide/tensor) and one output tensor. Layers are functions with a known mathematical structure that can be reused and have trainable variables. Most TensorFlow models are composed of layers. This model uses the [`Flatten`](https://www.tensorflow.org/api_docs/python/tf/keras/layers/Flatten), [`Dense`](https://www.tensorflow.org/api_docs/python/tf/keras/layers/Dense), and [`Dropout`](https://www.tensorflow.org/api_docs/python/tf/keras/layers/Dropout) layers.

For each example, the model returns a vector of [logits](https://developers.google.com/machine-learning/glossary#logits) or [log-odds](https://developers.google.com/machine-learning/glossary#log-odds) scores, one for each class.


```python
predictions = model(x_train[:1]).numpy()
predictions
```




    array([[ 0.94803625, -0.17926112, -0.43811807,  0.15165734, -0.03804074,
            -0.5368711 , -0.3137253 , -0.58049524, -0.47742867,  0.59479254]],
          dtype=float32)



The `tf.nn.softmax` function converts these logits to *probabilities* for each class: 


```python
tf.nn.softmax(predictions).numpy()
```




    array([[0.24586494, 0.07963749, 0.06147484, 0.11087501, 0.09171678,
            0.05569414, 0.06961784, 0.05331677, 0.05910512, 0.17269702]],
          dtype=float32)



Note: It is possible to bake the `tf.nn.softmax` function into the activation function for the last layer of the network. While this can make the model output more directly interpretable, this approach is discouraged as it's impossible to provide an exact and numerically stable loss calculation for all models when using a softmax output. 

Define a loss function for training using `losses.SparseCategoricalCrossentropy`:


```python
loss_fn = tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True)
```

The loss function takes a vector of ground truth values and a vector of logits and returns a scalar loss for each example. This loss is equal to the negative log probability of the true class: The loss is zero if the model is sure of the correct class.

This untrained model gives probabilities close to random (1/10 for each class), so the initial loss should be close to `-tf.math.log(1/10) ~= 2.3`.


```python
loss_fn(y_train[:1], predictions).numpy()
```




    np.float32(2.8878803)



Before you start training, configure and compile the model using Keras `Model.compile`. Set the [`optimizer`](https://www.tensorflow.org/api_docs/python/tf/keras/optimizers) class to `adam`, set the `loss` to the `loss_fn` function you defined earlier, and specify a metric to be evaluated for the model by setting the `metrics` parameter to `accuracy`.


```python
model.compile(optimizer='adam',
              loss=loss_fn,
              metrics=['accuracy'])
```

## Train and evaluate your model

Use the `Model.fit` method to adjust your model parameters and minimize the loss: 


```python
model.fit(x_train, y_train, epochs=5)
```

    Epoch 1/5


    WARNING: All log messages before absl::InitializeLog() is called are written to STDERR
    I0000 00:00:1742485705.529010   82260 service.cc:152] XLA service 0x7a427c004000 initialized for platform CUDA (this does not guarantee that XLA will be used). Devices:
    I0000 00:00:1742485705.529037   82260 service.cc:160]   StreamExecutor device (0): Tesla V100-PCIE-16GB, Compute Capability 7.0
    2025-03-20 16:48:25.555026: I tensorflow/compiler/mlir/tensorflow/utils/dump_mlir_util.cc:269] disabling MLIR crash reproducer, set env var `MLIR_CRASH_REPRODUCER_DIRECTORY` to enable.
    I0000 00:00:1742485705.658045   82260 cuda_dnn.cc:529] Loaded cuDNN version 90300


    [1m   1/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m54:17[0m 2s/step - accuracy: 0.0625 - loss: 2.4370

    [1m  15/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m6s[0m 4ms/step - accuracy: 0.2110 - loss: 2.2017  

    [1m  41/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m4s[0m 3ms/step - accuracy: 0.3889 - loss: 1.8513

    [1m  66/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m4s[0m 2ms/step - accuracy: 0.4771 - loss: 1.6358

    I0000 00:00:1742485706.479397   82260 device_compiler.h:188] Compiled cluster using XLA!  This line is logged at most once for the lifetime of the process.


    [1m  89/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m4s[0m 2ms/step - accuracy: 0.5306 - loss: 1.4927

    [1m 116/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m4s[0m 2ms/step - accuracy: 0.5750 - loss: 1.3688

    [1m 141/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.6059 - loss: 1.2787

    [1m 168/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.6320 - loss: 1.2012

    [1m 193/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.6517 - loss: 1.1424

    [1m 217/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.6677 - loss: 1.0940

    [1m 243/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.6827 - loss: 1.0485

    [1m 269/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.6956 - loss: 1.0090

    [1m 291/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.7050 - loss: 0.9795

    [1m 314/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.7139 - loss: 0.9519

    [1m 339/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.7226 - loss: 0.9249

    [1m 366/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.7310 - loss: 0.8986

    [1m 394/1875[0m [32m━━━━[0m[37m━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.7389 - loss: 0.8739

    [1m 418/1875[0m [32m━━━━[0m[37m━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.7451 - loss: 0.8544

    [1m 443/1875[0m [32m━━━━[0m[37m━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.7510 - loss: 0.8359

    [1m 470/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.7569 - loss: 0.8173

    [1m 496/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.7621 - loss: 0.8008

    [1m 523/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.7671 - loss: 0.7849

    [1m 550/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.7717 - loss: 0.7701

    [1m 577/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.7760 - loss: 0.7562

    [1m 602/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.7798 - loss: 0.7442

    [1m 627/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.7833 - loss: 0.7328

    [1m 651/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.7865 - loss: 0.7225

    [1m 678/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.7899 - loss: 0.7115

    [1m 705/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.7931 - loss: 0.7011

    [1m 729/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.7958 - loss: 0.6923

    [1m 755/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.7986 - loss: 0.6831

    [1m 778/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.8010 - loss: 0.6754

    [1m 805/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.8037 - loss: 0.6667

    [1m 831/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.8061 - loss: 0.6587

    [1m 857/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.8084 - loss: 0.6511

    [1m 884/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.8108 - loss: 0.6435

    [1m 912/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8131 - loss: 0.6360

    [1m 940/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8153 - loss: 0.6287

    [1m 967/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8173 - loss: 0.6220

    [1m 995/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8193 - loss: 0.6153

    [1m1023/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8213 - loss: 0.6089

    [1m1048/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8230 - loss: 0.6033

    [1m1072/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8245 - loss: 0.5981

    [1m1098/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8262 - loss: 0.5927

    [1m1124/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8278 - loss: 0.5875

    [1m1148/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8292 - loss: 0.5828

    [1m1175/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8307 - loss: 0.5777

    [1m1201/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8321 - loss: 0.5729

    [1m1218/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8331 - loss: 0.5699

    [1m1245/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8345 - loss: 0.5652

    [1m1272/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8358 - loss: 0.5606

    [1m1296/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8370 - loss: 0.5567

    [1m1323/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8383 - loss: 0.5524

    [1m1350/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.8396 - loss: 0.5483

    [1m1378/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.8408 - loss: 0.5440

    [1m1405/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.8420 - loss: 0.5401

    [1m1432/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.8432 - loss: 0.5362

    [1m1459/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.8443 - loss: 0.5324

    [1m1484/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.8454 - loss: 0.5290

    [1m1509/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.8464 - loss: 0.5257

    [1m1536/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.8474 - loss: 0.5222

    [1m1563/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.8485 - loss: 0.5187

    [1m1590/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.8495 - loss: 0.5154

    [1m1617/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.8505 - loss: 0.5121

    [1m1645/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.8515 - loss: 0.5087

    [1m1672/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.8524 - loss: 0.5056

    [1m1699/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.8533 - loss: 0.5025

    [1m1726/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.8542 - loss: 0.4995

    [1m1753/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.8551 - loss: 0.4966

    [1m1781/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.8560 - loss: 0.4936

    [1m1805/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.8567 - loss: 0.4911

    [1m1830/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.8575 - loss: 0.4885

    [1m1857/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.8583 - loss: 0.4857

    [1m1875/1875[0m [32m━━━━━━━━━━━━━━━━━━━━[0m[37m[0m [1m5s[0m 2ms/step - accuracy: 0.8589 - loss: 0.4839


    Epoch 2/5


    [1m   1/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m37s[0m 20ms/step - accuracy: 0.9375 - loss: 0.2357

    [1m  27/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9535 - loss: 0.1550  

    [1m  54/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9555 - loss: 0.1495

    [1m  82/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9556 - loss: 0.1492

    [1m 109/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9555 - loss: 0.1508

    [1m 136/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9552 - loss: 0.1526

    [1m 164/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9548 - loss: 0.1543

    [1m 191/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9545 - loss: 0.1554

    [1m 218/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9543 - loss: 0.1563

    [1m 245/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9541 - loss: 0.1573

    [1m 272/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9539 - loss: 0.1580

    [1m 299/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9537 - loss: 0.1586

    [1m 320/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9536 - loss: 0.1589

    [1m 343/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9534 - loss: 0.1593

    [1m 370/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9533 - loss: 0.1598

    [1m 397/1875[0m [32m━━━━[0m[37m━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9532 - loss: 0.1601

    [1m 425/1875[0m [32m━━━━[0m[37m━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9531 - loss: 0.1602

    [1m 450/1875[0m [32m━━━━[0m[37m━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9531 - loss: 0.1602

    [1m 469/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9531 - loss: 0.1602

    [1m 496/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9532 - loss: 0.1601

    [1m 523/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9532 - loss: 0.1600

    [1m 551/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9532 - loss: 0.1600

    [1m 578/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9532 - loss: 0.1600

    [1m 602/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9532 - loss: 0.1600

    [1m 628/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9533 - loss: 0.1600

    [1m 654/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9533 - loss: 0.1600

    [1m 680/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9533 - loss: 0.1600

    [1m 705/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9534 - loss: 0.1600

    [1m 727/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9534 - loss: 0.1599

    [1m 754/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9534 - loss: 0.1599

    [1m 781/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9534 - loss: 0.1599

    [1m 808/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9534 - loss: 0.1599

    [1m 835/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9535 - loss: 0.1598

    [1m 862/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9535 - loss: 0.1597

    [1m 885/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9535 - loss: 0.1597

    [1m 912/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9535 - loss: 0.1597

    [1m 937/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9535 - loss: 0.1596

    [1m 964/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9535 - loss: 0.1596

    [1m 991/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9535 - loss: 0.1595

    [1m1018/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9535 - loss: 0.1594

    [1m1046/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9535 - loss: 0.1593

    [1m1074/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9536 - loss: 0.1592

    [1m1101/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9536 - loss: 0.1591

    [1m1125/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9536 - loss: 0.1591

    [1m1152/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9536 - loss: 0.1590

    [1m1178/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9536 - loss: 0.1589

    [1m1205/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9536 - loss: 0.1588

    [1m1231/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9537 - loss: 0.1588

    [1m1259/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9537 - loss: 0.1587

    [1m1286/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9537 - loss: 0.1586

    [1m1313/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9537 - loss: 0.1585

    [1m1340/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9537 - loss: 0.1584

    [1m1367/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9537 - loss: 0.1583

    [1m1395/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9538 - loss: 0.1582

    [1m1422/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9538 - loss: 0.1581

    [1m1449/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9538 - loss: 0.1580

    [1m1472/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9538 - loss: 0.1579

    [1m1498/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9539 - loss: 0.1578

    [1m1519/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9539 - loss: 0.1577

    [1m1545/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9539 - loss: 0.1576

    [1m1572/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9539 - loss: 0.1575

    [1m1599/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9539 - loss: 0.1574

    [1m1625/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9540 - loss: 0.1573

    [1m1652/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9540 - loss: 0.1571

    [1m1677/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9540 - loss: 0.1570

    [1m1704/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.9540 - loss: 0.1569

    [1m1731/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.9541 - loss: 0.1568

    [1m1758/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.9541 - loss: 0.1567

    [1m1782/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.9541 - loss: 0.1565

    [1m1809/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.9542 - loss: 0.1564

    [1m1837/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.9542 - loss: 0.1563

    [1m1863/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.9542 - loss: 0.1561

    [1m1875/1875[0m [32m━━━━━━━━━━━━━━━━━━━━[0m[37m[0m [1m4s[0m 2ms/step - accuracy: 0.9542 - loss: 0.1561


    Epoch 3/5


    [1m   1/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m36s[0m 19ms/step - accuracy: 0.9688 - loss: 0.1065

    [1m  28/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9772 - loss: 0.1070  

    [1m  55/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9754 - loss: 0.1052

    [1m  81/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9745 - loss: 0.1051

    [1m 108/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9742 - loss: 0.1052

    [1m 132/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9736 - loss: 0.1062

    [1m 156/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9730 - loss: 0.1067

    [1m 183/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9723 - loss: 0.1080

    [1m 210/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9716 - loss: 0.1096

    [1m 237/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9709 - loss: 0.1109

    [1m 264/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9704 - loss: 0.1117

    [1m 291/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9700 - loss: 0.1125

    [1m 318/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9696 - loss: 0.1130

    [1m 345/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9693 - loss: 0.1134

    [1m 372/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9691 - loss: 0.1136

    [1m 399/1875[0m [32m━━━━[0m[37m━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9688 - loss: 0.1138

    [1m 426/1875[0m [32m━━━━[0m[37m━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9686 - loss: 0.1140

    [1m 453/1875[0m [32m━━━━[0m[37m━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9685 - loss: 0.1141

    [1m 480/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9683 - loss: 0.1141

    [1m 507/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9682 - loss: 0.1141

    [1m 534/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9682 - loss: 0.1140

    [1m 561/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9681 - loss: 0.1139

    [1m 588/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9681 - loss: 0.1138

    [1m 613/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9680 - loss: 0.1138

    [1m 640/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9680 - loss: 0.1137

    [1m 667/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9679 - loss: 0.1137

    [1m 694/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9679 - loss: 0.1136

    [1m 720/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9678 - loss: 0.1136

    [1m 746/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9677 - loss: 0.1136

    [1m 773/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9677 - loss: 0.1136

    [1m 799/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9676 - loss: 0.1136

    [1m 826/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9676 - loss: 0.1135

    [1m 853/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9676 - loss: 0.1135

    [1m 881/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9675 - loss: 0.1135

    [1m 908/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9675 - loss: 0.1134

    [1m 933/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9675 - loss: 0.1134

    [1m 957/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9674 - loss: 0.1134

    [1m 979/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9674 - loss: 0.1134

    [1m1005/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9674 - loss: 0.1133

    [1m1029/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9674 - loss: 0.1133

    [1m1053/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9674 - loss: 0.1133

    [1m1077/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9674 - loss: 0.1132

    [1m1102/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9674 - loss: 0.1132

    [1m1122/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9674 - loss: 0.1131

    [1m1149/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9674 - loss: 0.1131

    [1m1176/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9674 - loss: 0.1130

    [1m1203/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9674 - loss: 0.1130

    [1m1230/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9674 - loss: 0.1129

    [1m1257/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9674 - loss: 0.1129

    [1m1284/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9674 - loss: 0.1128

    [1m1311/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9674 - loss: 0.1127

    [1m1338/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9674 - loss: 0.1127

    [1m1365/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1126

    [1m1393/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1126

    [1m1421/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1125

    [1m1449/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1124

    [1m1476/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1124

    [1m1504/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1123

    [1m1531/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1123

    [1m1558/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1123

    [1m1585/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1122

    [1m1610/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1122

    [1m1635/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1122

    [1m1661/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1121

    [1m1688/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1121

    [1m1715/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1120

    [1m1742/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1120

    [1m1769/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1120

    [1m1796/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1119

    [1m1823/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1119

    [1m1849/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1119

    [1m1875/1875[0m [32m━━━━━━━━━━━━━━━━━━━━[0m[37m[0m [1m0s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1119

    [1m1875/1875[0m [32m━━━━━━━━━━━━━━━━━━━━[0m[37m[0m [1m4s[0m 2ms/step - accuracy: 0.9673 - loss: 0.1119


    Epoch 4/5


    [1m   1/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m37s[0m 20ms/step - accuracy: 0.9688 - loss: 0.0549

    [1m  28/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9639 - loss: 0.1023  

    [1m  55/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9668 - loss: 0.0974

    [1m  81/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9686 - loss: 0.0933

    [1m 107/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9694 - loss: 0.0915

    [1m 134/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9699 - loss: 0.0907

    [1m 161/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9700 - loss: 0.0904

    [1m 187/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9701 - loss: 0.0899

    [1m 213/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9703 - loss: 0.0894

    [1m 240/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9705 - loss: 0.0889

    [1m 264/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9707 - loss: 0.0886

    [1m 290/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9708 - loss: 0.0883

    [1m 317/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9709 - loss: 0.0882

    [1m 344/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9710 - loss: 0.0881

    [1m 368/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9710 - loss: 0.0880

    [1m 395/1875[0m [32m━━━━[0m[37m━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9711 - loss: 0.0879

    [1m 422/1875[0m [32m━━━━[0m[37m━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9712 - loss: 0.0878

    [1m 449/1875[0m [32m━━━━[0m[37m━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9712 - loss: 0.0878

    [1m 476/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9712 - loss: 0.0878

    [1m 504/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9713 - loss: 0.0879

    [1m 531/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9713 - loss: 0.0879

    [1m 556/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9713 - loss: 0.0879

    [1m 583/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9713 - loss: 0.0880

    [1m 610/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9713 - loss: 0.0882

    [1m 637/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9713 - loss: 0.0883

    [1m 664/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9713 - loss: 0.0884

    [1m 691/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9713 - loss: 0.0885

    [1m 718/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9712 - loss: 0.0886

    [1m 746/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9712 - loss: 0.0887

    [1m 773/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9712 - loss: 0.0887

    [1m 798/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9712 - loss: 0.0888

    [1m 823/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9712 - loss: 0.0888

    [1m 850/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9712 - loss: 0.0888

    [1m 878/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9712 - loss: 0.0889

    [1m 906/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9712 - loss: 0.0889

    [1m 933/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9712 - loss: 0.0889

    [1m 961/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9713 - loss: 0.0889

    [1m 988/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9713 - loss: 0.0889

    [1m1015/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9713 - loss: 0.0889

    [1m1042/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9713 - loss: 0.0889

    [1m1068/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9713 - loss: 0.0888

    [1m1095/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9713 - loss: 0.0888

    [1m1122/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9713 - loss: 0.0888

    [1m1150/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9714 - loss: 0.0888

    [1m1177/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9714 - loss: 0.0888

    [1m1203/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9714 - loss: 0.0888

    [1m1230/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9714 - loss: 0.0888

    [1m1257/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9714 - loss: 0.0888

    [1m1282/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9714 - loss: 0.0888

    [1m1308/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9714 - loss: 0.0888

    [1m1335/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9714 - loss: 0.0888

    [1m1362/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0888

    [1m1389/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0888

    [1m1414/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0888

    [1m1440/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0889

    [1m1468/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0889

    [1m1495/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0889

    [1m1522/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0890

    [1m1549/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0890

    [1m1576/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0890

    [1m1603/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0890

    [1m1629/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0890

    [1m1655/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0890

    [1m1677/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0890

    [1m1704/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0891

    [1m1731/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0891

    [1m1755/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0891

    [1m1774/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0891

    [1m1801/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0891

    [1m1826/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.9715 - loss: 0.0891

    [1m1849/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.9716 - loss: 0.0891

    [1m1870/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.9716 - loss: 0.0891

    [1m1875/1875[0m [32m━━━━━━━━━━━━━━━━━━━━[0m[37m[0m [1m4s[0m 2ms/step - accuracy: 0.9716 - loss: 0.0891


    Epoch 5/5


    [1m   1/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m48s[0m 26ms/step - accuracy: 1.0000 - loss: 0.0385

    [1m  27/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9755 - loss: 0.0618  

    [1m  46/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m4s[0m 2ms/step - accuracy: 0.9754 - loss: 0.0623

    [1m  70/1875[0m [37m━━━━━━━━━━━━━━━━━━━━[0m [1m4s[0m 2ms/step - accuracy: 0.9760 - loss: 0.0632

    [1m  97/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9764 - loss: 0.0638

    [1m 124/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0637

    [1m 150/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9770 - loss: 0.0639

    [1m 177/1875[0m [32m━[0m[37m━━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9769 - loss: 0.0648

    [1m 204/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9769 - loss: 0.0655

    [1m 231/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9769 - loss: 0.0659

    [1m 258/1875[0m [32m━━[0m[37m━━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0662

    [1m 284/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9769 - loss: 0.0664

    [1m 311/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9769 - loss: 0.0666

    [1m 338/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9769 - loss: 0.0667

    [1m 361/1875[0m [32m━━━[0m[37m━━━━━━━━━━━━━━━━━[0m [1m3s[0m 2ms/step - accuracy: 0.9769 - loss: 0.0669

    [1m 388/1875[0m [32m━━━━[0m[37m━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9769 - loss: 0.0672

    [1m 414/1875[0m [32m━━━━[0m[37m━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9769 - loss: 0.0674

    [1m 434/1875[0m [32m━━━━[0m[37m━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9769 - loss: 0.0675

    [1m 461/1875[0m [32m━━━━[0m[37m━━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0677

    [1m 488/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0679

    [1m 515/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0681

    [1m 543/1875[0m [32m━━━━━[0m[37m━━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0684

    [1m 570/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0687

    [1m 597/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0689

    [1m 621/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0691

    [1m 638/1875[0m [32m━━━━━━[0m[37m━━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0692

    [1m 660/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0693

    [1m 683/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0694

    [1m 710/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0695

    [1m 737/1875[0m [32m━━━━━━━[0m[37m━━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0696

    [1m 764/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0697

    [1m 792/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0698

    [1m 819/1875[0m [32m━━━━━━━━[0m[37m━━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0699

    [1m 846/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m2s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0700

    [1m 873/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0701

    [1m 900/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0702

    [1m 926/1875[0m [32m━━━━━━━━━[0m[37m━━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0703

    [1m 944/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0703

    [1m 971/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0704

    [1m 998/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0704

    [1m1025/1875[0m [32m━━━━━━━━━━[0m[37m━━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0705

    [1m1052/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0706

    [1m1074/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0706

    [1m1101/1875[0m [32m━━━━━━━━━━━[0m[37m━━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0707

    [1m1128/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0707

    [1m1150/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0708

    [1m1177/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0708

    [1m1204/1875[0m [32m━━━━━━━━━━━━[0m[37m━━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0708

    [1m1231/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0709

    [1m1257/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0709

    [1m1284/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0709

    [1m1311/1875[0m [32m━━━━━━━━━━━━━[0m[37m━━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0709

    [1m1338/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0710

    [1m1364/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m1s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0710

    [1m1390/1875[0m [32m━━━━━━━━━━━━━━[0m[37m━━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0710

    [1m1416/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0711

    [1m1442/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0711

    [1m1468/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0711

    [1m1495/1875[0m [32m━━━━━━━━━━━━━━━[0m[37m━━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0712

    [1m1522/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0712

    [1m1549/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0713

    [1m1576/1875[0m [32m━━━━━━━━━━━━━━━━[0m[37m━━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0713

    [1m1603/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0714

    [1m1630/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0714

    [1m1658/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0715

    [1m1685/1875[0m [32m━━━━━━━━━━━━━━━━━[0m[37m━━━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0715

    [1m1710/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0716

    [1m1734/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0717

    [1m1760/1875[0m [32m━━━━━━━━━━━━━━━━━━[0m[37m━━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0717

    [1m1787/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0718

    [1m1814/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0718

    [1m1841/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.9768 - loss: 0.0719

    [1m1868/1875[0m [32m━━━━━━━━━━━━━━━━━━━[0m[37m━[0m [1m0s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0720

    [1m1875/1875[0m [32m━━━━━━━━━━━━━━━━━━━━[0m[37m[0m [1m4s[0m 2ms/step - accuracy: 0.9767 - loss: 0.0720





    <keras.src.callbacks.history.History at 0x7a4348326120>



The `Model.evaluate` method checks the model's performance, usually on a [validation set](https://developers.google.com/machine-learning/glossary#validation-set) or [test set](https://developers.google.com/machine-learning/glossary#test-set).


```python
model.evaluate(x_test,  y_test, verbose=2)
```

    313/313 - 1s - 4ms/step - accuracy: 0.9779 - loss: 0.0728





    [0.07277049124240875, 0.9779000282287598]



The image classifier is now trained to ~98% accuracy on this dataset. To learn more, read the [TensorFlow tutorials](https://www.tensorflow.org/tutorials/).

If you want your model to return a probability, you can wrap the trained model, and attach the softmax to it:


```python
probability_model = tf.keras.Sequential([
  model,
  tf.keras.layers.Softmax()
])
```


```python
probability_model(x_test[:5])
```




    <tf.Tensor: shape=(5, 10), dtype=float32, numpy=
    array([[2.8376219e-06, 1.0471457e-07, 4.0286090e-05, 2.6145875e-03,
            2.8866856e-09, 1.1721941e-05, 9.4427400e-12, 9.9707234e-01,
            1.8701890e-05, 2.3933555e-04],
           [7.5173340e-08, 5.3917838e-04, 9.9939740e-01, 1.5039336e-05,
            1.4316588e-14, 2.9401062e-05, 2.2957536e-06, 6.0391285e-15,
            1.6708931e-05, 1.4064245e-12],
           [4.9349666e-07, 9.9948114e-01, 9.1753136e-05, 1.0070295e-05,
            1.8723396e-05, 1.4154985e-05, 4.9788072e-05, 1.5073200e-04,
            1.8154497e-04, 1.6055042e-06],
           [9.9930561e-01, 9.8004382e-10, 4.4274992e-05, 2.8321915e-07,
            1.0374725e-06, 1.1009623e-05, 6.3453999e-04, 4.3986697e-07,
            2.6237464e-07, 2.6415739e-06],
           [5.0560979e-05, 8.2661806e-08, 1.3211039e-04, 8.8184161e-06,
            9.8267269e-01, 2.4010591e-05, 3.3783108e-05, 2.0324685e-04,
            1.9959445e-05, 1.6854785e-02]], dtype=float32)>



## Conclusion

Congratulations! You have trained a machine learning model using a prebuilt dataset using the [Keras](https://www.tensorflow.org/guide/keras/overview) API.

For more examples of using Keras, check out the [tutorials](https://www.tensorflow.org/tutorials/keras/). To learn more about building models with Keras, read the [guides](https://www.tensorflow.org/guide/keras). If you want learn more about loading and preparing data, see the tutorials on [image data loading](https://www.tensorflow.org/tutorials/load_data/images) or [CSV data loading](https://www.tensorflow.org/tutorials/load_data/csv).

