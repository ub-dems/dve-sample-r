INSTALL_POETRY_ENV <- TRUE
INSTALL_POETRY_ENV <- FALSE
if (INSTALL_POETRY_ENV) {
  
  system("poetry env info")
  system("poetry env use $(which python)")
  system("poetry install")

  reticulate::py_discover_config()
}
  
library(reticulate)
library(tensorflow)
library(keras)

reticulate::py_config()



INSTALL_KERAS <- TRUE
INSTALL_KERAS <- FALSE
if (INSTALL_KERAS) {
  
  keras::install_keras()
  
}

py_tf <- import("tensorflow", as="tf")
py_tf$config$list_physical_devices('GPU')


# from: https://cran.r-project.org/web/packages/keras/vignettes/index.html


mnist <- dataset_mnist()
x_train <- mnist$train$x
y_train <- mnist$train$y
x_test <- mnist$test$x
y_test <- mnist$test$y


# reshape
x_train <- array_reshape(x_train, c(nrow(x_train), 784))
x_test <- array_reshape(x_test, c(nrow(x_test), 784))
# rescale
x_train <- x_train / 255
x_test <- x_test / 255

y_train <- to_categorical(y_train, 10)
y_test <- to_categorical(y_test, 10)

model <- keras_model_sequential() 
model %>% 
  layer_dense(units = 256, activation = 'relu', input_shape = c(784)) %>% 
  layer_dropout(rate = 0.4) %>% 
  layer_dense(units = 128, activation = 'relu') %>%
  layer_dropout(rate = 0.3) %>%
  layer_dense(units = 10, activation = 'softmax')

summary(model)

model %>% compile(
  loss = 'categorical_crossentropy',
  optimizer = optimizer_rmsprop(),
  metrics = c('accuracy')
)


history <- model %>% fit(
  x_train, y_train, 
  epochs = 30, batch_size = 128, 
  validation_split = 0.2
)


model %>% evaluate(x_test, y_test)

# model %>% predict_classes(x_test)

model %>% predict(x_test) %>% k_argmax()
model %>% predict(x_test) %>% `>`(0.5) %>% k_cast("int32")

