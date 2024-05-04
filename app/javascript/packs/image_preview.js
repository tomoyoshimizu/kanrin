  document.addEventListener("turbolinks:load", () => {

    const initFormImagePrewiew = (function() {

      const inputElement = document.getElementById("image-file-field");

      const api_url = "https://vision.googleapis.com/v1/images:annotate";
      const api_key = "<%= ENV['GOOGLE_API_KEY'] %>";
      const maxFileSize = 1024 * 1024 * 2;
      const defaultImage = `<%= j(image_tag image, alt: "プレビュー") %>`;

      /**
       * バイト書式変換
       * @param {number} number 適用する数値
       * @param {number} [point=0] 小数点の桁数
       * @param {number} [com=1024] 1KBあたりのバイト数
       * @return {string} 書式化された値を返す
       */
      const byteFormat = function(number, point, com) {
        if (typeof number === "undefined") throw "適用する数値が指定されていません。";
        if (!String(number).match(/^[0-9][0-9\.]+?/)) throw "適用する数値に誤りがあります。";
        if (!point) point = 0;
        if (!com) com = 1024;

        const bytes  = Number(number),
              suffix = ["Byte", "KB", "MB", "GB", "TB", "PB", "ZB", "YB"],
              target = Math.floor(Math.log(bytes) / Math.log(com));

        return (bytes / Math.pow(com, Math.floor(target))).toFixed(point) + suffix[target];
      };

      const attachImagePreview = (source) => {
        let wrapImgPreview = document.getElementById("wrap-image-preview");
        wrapImgPreview.innerHTML = source ? `<img src="${source}" alt="プレビュー">` : defaultImage;
      }

      // Read input file
      const readFile = (file) => {
        let fileReader = new FileReader();
        const promise = new Promise((resolve, reject) => {
          fileReader.onload = (event) => {
            attachImagePreview(event.target.result);
            resolve(event.target.result.replace(/^data:image\/(png|jpeg);base64,/, ""));
          };
        })
        fileReader.readAsDataURL(file);
        return promise;
      };

      // Send API Request to Cloud Vision API
      const sendAPI = (base64string) => {
        let params = {
          requests: [
            {
              image: { content: base64string },
              features: [
                { type: "SAFE_SEARCH_DETECTION" }
              ]
            }
          ]
        };
        let xhr = new XMLHttpRequest();
        xhr.open("POST", `${api_url}?key=${api_key}`, true);
        xhr.setRequestHeader("Content-Type", "application/json");
        const promise = new Promise((resolve, reject) => {
          xhr.onreadystatechange = () => {
            if (xhr.readyState != XMLHttpRequest.DONE) return;
            if (xhr.status >= 400) return reject({message: `Failed with ${xhr.status}:${xhr.statusText}`});
            resolve(JSON.parse(xhr.responseText));
          };
        })
        xhr.send(JSON.stringify(params));
        return promise;
      }

      const afterResponse = (response) => {
        console.log("Successfully API requests.", JSON.stringify(response, null, 2));
        let safeSearchAnnotation = response["responses"][0]["safeSearchAnnotation"];

        let safeSeaechDetectionForms = document.querySelectorAll("input[data-category]")
        safeSeaechDetectionForms.forEach((element) => {
          let category = element.getAttribute("data-category");
          let likelihood = safeSearchAnnotation[category];
          element.value = likelihood;
        });

        let targetCategory = ["adult", "medical", "violence", "racy"];
        let targetLikelihood  = ["POSSIBLE", "LIKELY", "VERY_LIKELY"];
        let result = targetCategory.some((category) => targetLikelihood.includes(safeSearchAnnotation[category]));
        if (result) { showWarning(true) };
      }

      const check

      const resetImagePreview = (event) => {
        event.target.value = "";
        attachImagePreview(false);
        let safeSeaechDetectionForms = document.querySelectorAll("input[data-category]");
        safeSeaechDetectionForms.forEach((element) => element.value = "");
        showWarning(false);
      }

      const showWarning = (boolean) =>{
        let warning = document.getElementById("warning");
        let checkBox = document.getElementById("post_confirm_warning");
        checkBox.checked = false;
        if(boolean){
          checkBox.setAttribute("required", true);
          warning.setAttribute("aria-hidden", false);
        } else {
          checkBox.removeAttribute("required");
          warning.setAttribute("aria-hidden", true);
        }
      }

      const disableBtnSubmit = (boolean) =>{
        let btnSubmit = document.getElementById("btn-submit");
        if(boolean){
          btnSubmit.setAttribute("disabled", true);
        } else {
          btnSubmit.removeAttribute("disabled");
        }
      }

      let clone = inputElement.cloneNode(true);

      clone.addEventListener("click", resetImagePreview, false);
      clone.addEventListener("change", (event) => {
        if (event.target.files[0].size > maxFileSize) {
          alert(`${byteFormat(maxFileSize)}を越えるファイルはアップロードできません。`);
          event.target.value = "";
        } else {
          disableBtnSubmit(true);
          Promise.resolve(event.target.files[0])
            .then(readFile)
            .then(sendAPI)
            .then(afterResponse)
            .then(response => {
              disableBtnSubmit(false);
            })
            .catch(error => {
              console.error(error);
              alert("画像のアップロードに失敗しました。");
              resetImagePreview(event);
              disableBtnSubmit(false);
            });
        }
      }, false);

      inputElement.replaceWith(clone);
    }());

  });