document.addEventListener("turbolinks:load", () => {

  const initFormImagePrewiew = () => {
    const inputElement     = document.getElementById("image-preview-file-field");
    const maxFileSize      = inputElement.getAttribute("data-maximum");
    const apiRequestUrl    = inputElement.getAttribute("data-apirequesturl");
    const apiRequestMethod = inputElement.getAttribute("data-apirequestmethod");
    const defaultImgSource = document.getElementById("image-preview").getAttribute("src");

    const overMaxFileSize = () => {
      const byteFormat = (number, point = 0, com = 1024) => {
        const bytes  = Number(number);
        const suffix = ["Byte", "KB", "MB", "GB", "TB", "PB", "ZB", "YB"];
        const target = Math.floor(Math.log(bytes) / Math.log(com));

        return (bytes / Math.pow(com, Math.floor(target))).toFixed(point) + suffix[target];
      };

      alert(`${byteFormat(maxFileSize)}を越えるファイルはアップロードできません。`);
      event.target.value = "";
    }

    const resetImagePreview = (event) => {
      event.target.value = "";
      document.getElementById("image-preview").setAttribute("src", defaultImgSource);
      if (apiRequestUrl && apiRequestMethod) {
        inputLikelihoodValue(false);
        showAlert(false);
      }
    };

    const disableBtnSubmit = (boolean) => {
      const btnSubmit = document.getElementById("btn-submit");

      if (boolean) {
        btnSubmit.setAttribute("disabled", true);
      } else {
        btnSubmit.removeAttribute("disabled");
      }
    };

    const inputLikelihoodValue = (source) => {
      const formFilelds = document.querySelectorAll("input[data-category]");

      formFilelds.forEach((element) => {
        element.value = source ? source[element.getAttribute("data-category")] : "";
      });
    };

    const showAlert = (boolean) => {
      const alertElement = document.getElementById("safe-seaech-detection-alert");
      const checkBox     = alertElement.querySelector(`input[type="checkbox"]`);

      checkBox.checked = false;
      if (boolean) {
        checkBox.setAttribute("required", true);
      } else {
        checkBox.removeAttribute("required");
      }
      alertElement.setAttribute("aria-hidden", !boolean);
    };

    const readFile = (file) => {
      const fileReader = new FileReader();

      fileReader.readAsDataURL(file);

      const promise = new Promise((resolve, reject) => {
        fileReader.onload = (event) => {
          if(!event.target.result) return reject("Failed image upload.");
          document.getElementById("image-preview").setAttribute("src", event.target.result);
          resolve(event.target.result);
        };
      })
      return promise;
    };

    const sendApiRequest = (file) => {
      const request   = new XMLHttpRequest();
      const csrfToken = document.querySelector(`meta[name="csrf-token"]`).getAttribute("content");

      const base64string = file.replace(/^data:image\/(png|jpeg);base64,/, "");
      const params = {
        requests: [
          {
            image: { content: base64string },
            features: [
              { type: "SAFE_SEARCH_DETECTION" }
            ]
          }
        ]
      };

      request.open(apiRequestMethod, apiRequestUrl, true);
      request.setRequestHeader('X-CSRF-Token', csrfToken);
      request.setRequestHeader("Content-Type", "application/json");
      request.send(JSON.stringify(params));

      const promise = new Promise((resolve, reject) => {
        request.onreadystatechange = () => {
          if (request.readyState != XMLHttpRequest.DONE) return;
          if (request.status >= 400) return reject(`Failed with ${request.status}:${request.statusText}`);
          resolve(JSON.parse(request.response));
        };
      });
      return promise;
    };

    const checkApiResponse = (response) => {
      console.log("Successfully API requests.", JSON.stringify(response, null, 2));

      const promise = new Promise((resolve, reject) => {
        if(response["responses"][0]["error"]) return reject(response["responses"][0]["error"]["message"]);
        resolve(response["responses"][0]["safeSearchAnnotation"]);
      })
      return promise;
    };

    const postProcessing = (response) => {
      const hasHighLikelihood = (source) => {
        const targetCategory    = ["adult", "medical", "violence", "racy"];
        const targetLikelihood  = ["POSSIBLE", "LIKELY", "VERY_LIKELY"];

        return targetCategory.some((category) => targetLikelihood.includes(source[category]));
      };

      if (hasHighLikelihood(response)) {
        inputLikelihoodValue(response);
        showAlert(true);
      } else {
        inputLikelihoodValue(false);
        showAlert(false);
      }
    };

    const uploadEvent = (event) => {
      if (event.target.files[0].size > maxFileSize) {
        overMaxFileSize();
      } else {
        disableBtnSubmit(true);
        Promise.resolve(event.target.files[0])
          .then(readFile)
          .catch((error) => {
            alert("画像のアップロードに失敗しました。");
            console.error(error);
            resetImagePreview(event);
          })
          .finally(() => {
            disableBtnSubmit(false);
          });
      }
    }

    const uploadEventWithApiRequest = (event) => {
      if (event.target.files[0].size > maxFileSize) {
        overMaxFileSize();
      } else {
        disableBtnSubmit(true);
        Promise.resolve(event.target.files[0])
          .then(readFile)
          .then(sendApiRequest)
          .then(checkApiResponse)
          .then(postProcessing)
          .catch((error) => {
            alert("画像のアップロードに失敗しました。");
            console.error(error);
            resetImagePreview(event);
          })
          .finally(() => {
            disableBtnSubmit(false);
          });
      }
    }

    const clone = inputElement.cloneNode(true);
    clone.addEventListener("click", resetImagePreview, false);
    if(apiRequestUrl && apiRequestMethod){
      clone.addEventListener("change", uploadEventWithApiRequest, false);
    } else {
      clone.addEventListener("change", uploadEvent, false);
    }
    inputElement.replaceWith(clone);
  };

  if (document.getElementById("image-preview-file-field")){
    initFormImagePrewiew();
  };
}, false);