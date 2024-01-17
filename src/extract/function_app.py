import azure.functions as func
import datetime
import logging

app = func.FunctionApp()

@app.function_name(name="extract_function")
@app.blob_trigger(arg_name="inputblob", path="1-ingest/{name}",
                  connection="blobstorage")
@app.blob_output(arg_name="outputblob", path="2-extracted/{name}-output.txt", connection="blobstorage")
def test_function(inputblob: func.InputStream, outputblob: func.Out[str]):
   logging.info(f"Triggered item: {inputblob.name}\n")
   dt = datetime.datetime.now().strftime("%I:%M%p on %B %d, %Y")
   outputblob.set(dt)
